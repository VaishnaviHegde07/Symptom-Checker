import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:symptom_checker/utils/response_handler.dart';

class MedicationService {
  static Future fetchDrugs(String disease) async {
    try {
      final response = await http.get(Uri.parse(
          'https://drug-app-7o2mnqk4sa-as.a.run.app/getDrugs/$disease'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return Success(code: response.statusCode, successResponse: data);
      } else if (response.statusCode == 404) {
        return Failure(code: 404, errorResponse: response.toString());
      }
    } catch (e) {
      return Failure(code: -1, errorResponse: e.toString());
    }
  }
}
