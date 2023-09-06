import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:symptom_checker/controllers/check_internet_connection.dart';
import 'package:symptom_checker/controllers/disease_symptoms_controller.dart';
import 'package:symptom_checker/utils/colors.dart';
import 'package:symptom_checker/utils/custom_titles.dart';
import 'package:provider/provider.dart';
import 'package:symptom_checker/utils/no_internet_widget.dart';

class DrugTreatment extends StatefulWidget {
  final String selectedDisease;
  const DrugTreatment({super.key, required this.selectedDisease});

  @override
  State<DrugTreatment> createState() => _DrugTreatmentState();
}

class _DrugTreatmentState extends State<DrugTreatment> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final diseaseSymptomsVM =
          Provider.of<DiseaseSymptoms>(context, listen: false);
      await diseaseSymptomsVM.getDrgs(widget.selectedDisease);
      Provider.of<ConnectivityViewModel>(context, listen: false)
          .startMonitoring();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DiseaseSymptoms diseaseSymptoms = Provider.of<DiseaseSymptoms>(context);
    ConnectivityViewModel connectivityViewModel =
        Provider.of<ConnectivityViewModel>(context);
    final mediaQuery = MediaQuery.of(context);
    return connectivityViewModel.isOnline!
        ? SafeArea(
            child: Scaffold(
                backgroundColor: backgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.arrow_back, size: 30)),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.02),
                      diseaseSymptoms.dataloading
                          ? Center(
                              heightFactor: 20,
                              child: CircularProgressIndicator(
                                color: buttonColor,
                              ),
                            )
                          : diseaseSymptoms.drugs.isEmpty
                              ? const Center(
                                  heightFactor: 20,
                                  child: Heading(
                                      title: "Sorry! No medication found"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Heading(
                                          title:
                                              "Drug Treatment for ${widget.selectedDisease}"),
                                      SizedBox(
                                          height:
                                              mediaQuery.size.height * 0.025),
                                      const Subheading(
                                          title:
                                              "Explore Medications for Managing the Condition"),
                                      SizedBox(
                                          height:
                                              mediaQuery.size.height * 0.025),
                                      ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          itemCount:
                                              diseaseSymptoms.drugs.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  top: 8,
                                                  bottom: 8,
                                                  right: 20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .bandage_fill,
                                                        size: 20,
                                                        color: buttonColor,
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Expanded(
                                                        child: Text(
                                                          (diseaseSymptoms
                                                              .drugs[index]),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  buttonColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                )
                    ],
                  ),
                )),
          )
        : NoInternet();
  }
}
