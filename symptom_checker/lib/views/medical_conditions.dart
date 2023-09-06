import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:symptom_checker/controllers/check_internet_connection.dart';
import 'package:symptom_checker/controllers/disease_symptoms_controller.dart';
import 'package:symptom_checker/utils/colors.dart';
import 'package:symptom_checker/utils/custom_titles.dart';
import 'package:symptom_checker/utils/no_internet_widget.dart';
import 'package:symptom_checker/utils/percentage_indicator.dart';
import 'package:symptom_checker/views/drug_treatment.dart';
import 'package:provider/provider.dart';

class MedicalCondition extends StatefulWidget {
  const MedicalCondition({super.key});

  @override
  State<MedicalCondition> createState() => _MedicalConditionState();
}

class _MedicalConditionState extends State<MedicalCondition> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final diseaseSymptomsVM =
          Provider.of<DiseaseSymptoms>(context, listen: false);
      diseaseSymptomsVM.findTopKDisease();
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
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Heading(
                                  title: "Symptom-Based Medical Condition"),
                              SizedBox(height: mediaQuery.size.height * 0.025),
                              const Subheading(
                                  title:
                                      "Top 5 Possible Health Conditions Based on Symptoms"),
                              SizedBox(height: mediaQuery.size.height * 0.025),
                              SizedBox(
                                height: mediaQuery.size.height * 0.7,
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemCount: diseaseSymptoms.topK.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => DrugTreatment(
                                              selectedDisease: diseaseSymptoms
                                                  .topK[index][0]));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              width: 312,
                                              height: 95,
                                              padding: const EdgeInsets.all(16),
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                shadows: const [
                                                  BoxShadow(
                                                    color: Color(0x19061058),
                                                    blurRadius: 16,
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        mediaQuery.size.height *
                                                            0.25,
                                                    child: Text(
                                                      (diseaseSymptoms
                                                          .topK[index][0]),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: purplyblue,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      CircularProgressBar(
                                                        progressPercentage:
                                                            diseaseSymptoms
                                                                .topK[index][1],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ),
                                      );
                                    }),
                              )
                            ])),
                  ],
                ),
              ),
            ),
          )
        : NoInternet();
  }
}
