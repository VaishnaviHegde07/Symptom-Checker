import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:symptom_checker/service/drugs_service.dart';
import 'package:symptom_checker/utils/response_handler.dart';

class DiseaseSymptoms extends ChangeNotifier {
  List<List<dynamic>> csvData = [];
  Map<String, List<Set<String>>> diseaseSymptoms = {};
  Set<String> totalSymptoms = {};
  Set<String> userInput = {};
  List<List<dynamic>> topK = [];
  List<String> drugs = [];

  void clearUserInput() {
    userInput.clear();
    notifyListeners();
  }

  void removeUserInput(String item) {
    userInput.remove(item);
    notifyListeners();
  }

  Future populateDiseaseSymptoms() async {
    final rawData = await rootBundle.loadString("assets/csv/symptoms.csv");
    csvData = const CsvToListConverter(
      eol: "\n",
    ).convert(rawData);

    for (List<dynamic> entry in csvData) {
      String disease = entry[0];
      if (disease == "") {
        continue;
      }
      List<String> symptoms = List<String>.from(entry.sublist(1));
      symptoms.removeWhere((symptom) => symptom.isEmpty);
      if (!diseaseSymptoms.containsKey(disease)) {
        diseaseSymptoms[disease] = [];
      }
      diseaseSymptoms[disease]?.add(symptoms.toSet());
      totalSymptoms.addAll(symptoms.toSet());
    }

    notifyListeners();
  }

  void findTopKDisease() {
    List<Set<String>> globalMaximaSymptoms = [];
    List<double> probability = [];
    List<String> diseaseNames = [];
    topK = [];
    for (var disease in diseaseSymptoms.keys) {
      List<Set<String>> symptoms = diseaseSymptoms[disease]!;
      Set<String> localMaximaSymtoms = {};
      int originalLength = 1;
      for (final checkSymptoms in symptoms) {
        final intersectionSet = checkSymptoms.intersection(userInput);
        if (localMaximaSymtoms.length < intersectionSet.length) {
          localMaximaSymtoms = intersectionSet;
          originalLength = checkSymptoms.length;
        }
      }
      globalMaximaSymptoms.add(localMaximaSymtoms);
      diseaseNames.add(disease);
      probability.add((localMaximaSymtoms.length / originalLength) * 100);
      if (kDebugMode) {
        print("$disease : $localMaximaSymtoms ");
        print("$probability Probability");
      }
    }

    List<List<dynamic>> sortedGlobalMaxima = List.generate(
      globalMaximaSymptoms.length,
      (index) => [
        diseaseNames[index],
        globalMaximaSymptoms[index],
        probability[index]
      ],
    );

    sortedGlobalMaxima.sort((a, b) => b[2].compareTo(a[2]));
    int k = 0;
    if (kDebugMode) {
      for (var entry in sortedGlobalMaxima) {
        print("Disease: ${entry[0]}, Global Maxima Symptoms: ${entry[1]}");
        if (k == 4) {
          break;
        }
        k = k + 1;
      }
    }

    int topDiseasesCount = 5;
    for (int i = 0;
        i < topDiseasesCount && i < sortedGlobalMaxima.length;
        i++) {
      final disease = sortedGlobalMaxima[i][0];
      final totalSymptomsCount = sortedGlobalMaxima[i][2];

      if (sortedGlobalMaxima[i][2] > 0) {
        topK.add([disease, sortedGlobalMaxima[i][2]]);
      }

      if (totalSymptomsCount != 0) {
        if (kDebugMode) {
          print("Disease: $disease, Probability: $probability");
        }
      }
    }
    notifyListeners();
  }

  bool _dataloading = false;
  bool get dataloading => _dataloading;
  void setDataLoading(bool loading) {
    _dataloading = loading;
    notifyListeners();
  }

  Future<dynamic> getDrgs(String disease) async {
    setDataLoading(true);
    try {
      final response = await MedicationService.fetchDrugs(disease);
      if (response is Success) {
        drugs = List<String>.from(response.successResponse);
        if (kDebugMode) {
          print(drugs);
        }
      } else if (response is Failure) {
        setDataLoading(false);
        drugs = [];
      }
      setDataLoading(false);
    } catch (e) {
      drugs = [];
      if (kDebugMode) {
        print('Error: $e');
      }
      setDataLoading(false);
    }
  }
}
