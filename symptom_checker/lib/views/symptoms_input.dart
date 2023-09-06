import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:symptom_checker/controllers/check_internet_connection.dart';
import 'package:symptom_checker/controllers/disease_symptoms_controller.dart';
import 'package:symptom_checker/utils/button.dart';
import 'package:symptom_checker/utils/colors.dart';
import 'package:symptom_checker/utils/custom_container.dart';
import 'package:symptom_checker/utils/custom_titles.dart';
import 'package:symptom_checker/utils/no_internet_widget.dart';
import 'package:symptom_checker/utils/search_field.dart';
import 'package:symptom_checker/views/medical_conditions.dart';
import 'package:provider/provider.dart';

class SymptomInputScreen extends StatefulWidget {
  const SymptomInputScreen({super.key});

  @override
  State<SymptomInputScreen> createState() => _SymptomInputScreenState();
}

class _SymptomInputScreenState extends State<SymptomInputScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredList = [];
  List<String> originalList = [];
  bool showClearButton = false;
  List<bool> checkboxValues = [];
  List<bool> filteredCheckboxValues = [];
  bool noData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final diseaseSymptomsVM =
          Provider.of<DiseaseSymptoms>(context, listen: false);
      await diseaseSymptomsVM.populateDiseaseSymptoms();
      setState(() {
        checkboxValues =
            List<bool>.filled(diseaseSymptomsVM.totalSymptoms.length, false);
        originalList = diseaseSymptomsVM.totalSymptoms.toList();
        checkboxValues = List<bool>.filled(originalList.length, false);
        filteredCheckboxValues = List<bool>.filled(filteredList.length, false);
      });
      Provider.of<ConnectivityViewModel>(context, listen: false)
          .startMonitoring();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diseaseSymptoms = Provider.of<DiseaseSymptoms>(context);
    ConnectivityViewModel connectivityViewModel =
        Provider.of<ConnectivityViewModel>(context);
    final mediaQuery = MediaQuery.of(context);
    return connectivityViewModel.isOnline!
        ? SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: mediaQuery.size.height * 0.06),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Heading(title: "Choose Your Symptoms"),
                          SizedBox(height: mediaQuery.size.height * 0.025),
                          const Subheading(
                              title:
                                  "Please select the symptoms you are experiencing."),
                          SizedBox(height: mediaQuery.size.height * 0.025),
                          Container(
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: lightBlue,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3))
                              ],
                              border: Border.all(color: lightBlue),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                                bottomLeft: Radius.circular(25.0),
                                bottomRight: Radius.circular(25.0),
                              ),
                              color: pureWhite,
                            ),
                            height: mediaQuery.size.height * 0.45,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: showSearchField(diseaseSymptoms),
                                ),
                                diseaseSymptoms.userInput.isNotEmpty
                                    ? textButton(
                                        title: "Clear selection",
                                        color: buttonColor,
                                        onPressed: () {
                                          setState(() {
                                            showClearButton = false;
                                            searchController.clear();
                                            diseaseSymptoms.userInput.clear();
                                            filteredList.clear();
                                            checkboxValues.fillRange(0,
                                                checkboxValues.length, false);
                                            filteredCheckboxValues.fillRange(
                                                0,
                                                filteredCheckboxValues.length,
                                                false);
                                          });
                                        })
                                    : Container(),
                                noData
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 40.0),
                                        child: Center(
                                          child: Text(
                                            "No matching symptoms found",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: purplyblue,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0, left: 8, right: 8),
                                          child: Scrollbar(
                                            thickness: 2,
                                            child: ListView.builder(
                                              padding: const EdgeInsets.all(0),
                                              itemCount: filteredList.isNotEmpty
                                                  ? filteredList.length
                                                  : diseaseSymptoms
                                                      .totalSymptoms.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final originalIndex =
                                                    originalList.indexOf(
                                                        filteredList
                                                                .isNotEmpty
                                                            ? filteredList
                                                                .elementAt(
                                                                    index)
                                                            : diseaseSymptoms
                                                                .totalSymptoms
                                                                .elementAt(
                                                                    index));
                                                final isChecked = filteredList
                                                        .isNotEmpty
                                                    ? filteredCheckboxValues[
                                                        index]
                                                    : checkboxValues[
                                                        originalIndex];

                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CupertinoCheckbox(
                                                          checkColor: pureWhite,
                                                          activeColor:
                                                              buttonColor,
                                                          value: isChecked,
                                                          onChanged: (value) {
                                                            onCheckBoxClicked(
                                                                index, value!);
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          (filteredList
                                                                      .isNotEmpty
                                                                  ? filteredList
                                                                      .elementAt(
                                                                          index)
                                                                  : diseaseSymptoms
                                                                      .totalSymptoms
                                                                      .elementAt(
                                                                          index))
                                                              .replaceAll(
                                                                  RegExp(r'_'),
                                                                  ' '),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: purplyblue,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(height: mediaQuery.size.height * 0.04),
                          cupertinoButton(
                              title: "Continue",
                              color: diseaseSymptoms.userInput.isNotEmpty
                                  ? buttonColor
                                  : null,
                              onPressed: () {
                                if (diseaseSymptoms.userInput.isNotEmpty) {
                                  Get.to(() => const MedicalCondition());
                                }
                              }),
                          showUserSelectedSymptoms(diseaseSymptoms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const NoInternet();
  }

  Widget showUserSelectedSymptoms(DiseaseSymptoms diseaseSymptoms) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: mediaQuery.size.height * 0.04),
        diseaseSymptoms.userInput.isNotEmpty
            ? Text(
                "Your symptoms :",
                style: TextStyle(
                  fontSize: 20,
                  color: purplyblue,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Container(),
        SizedBox(height: mediaQuery.size.height * 0.02),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: diseaseSymptoms.userInput.length <= 2
              ? diseaseSymptoms.userInput
                  .map((item) => CustomContainer(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.replaceAll(RegExp(r'_'), ' '),
                              style:
                                  TextStyle(color: buttonColor, fontSize: 16),
                            ),
                            const SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  diseaseSymptoms.userInput.remove(item);
                                  final index = diseaseSymptoms.totalSymptoms
                                      .toList()
                                      .indexOf(item);
                                  checkboxValues[index] = false;
                                  if (filteredList.isNotEmpty) {
                                    final indexOfFiltered =
                                        filteredList.indexOf(item);
                                    filteredCheckboxValues[indexOfFiltered] =
                                        false;
                                  }
                                });
                              },
                              child: Icon(Icons.close, color: buttonColor),
                            ),
                          ],
                        ),
                      ))
                  .toList()
              : diseaseSymptoms.userInput
                  .toList()
                  .sublist(0, 2)
                  .map((item) => CustomContainer(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.replaceAll(RegExp(r'_'), ' '),
                              style: TextStyle(color: buttonColor),
                            ),
                            const SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  diseaseSymptoms.userInput.remove(item);
                                  final index = diseaseSymptoms.totalSymptoms
                                      .toList()
                                      .indexOf(item);
                                  checkboxValues[index] = false;
                                  if (filteredList.isNotEmpty) {
                                    final indexOfFiltered =
                                        filteredList.indexOf(item);
                                    filteredCheckboxValues[indexOfFiltered] =
                                        false;
                                  }
                                });
                              },
                              child: Icon(Icons.close, color: buttonColor),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
        ),
        if (diseaseSymptoms.userInput.length > 2)
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                isDismissible: false,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10.0)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Your symptoms : ",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: purplyblue,
                                    fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: diseaseSymptoms.userInput
                                  .map((item) => CustomContainer(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item.replaceAll(
                                                  RegExp(r'_'), ' '),
                                              style:
                                                  TextStyle(color: buttonColor),
                                            ),
                                            const SizedBox(width: 8.0),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // diseaseSymptoms.userInput
                                                  //     .remove(item);
                                                  final index = diseaseSymptoms
                                                      .totalSymptoms
                                                      .toList()
                                                      .indexOf(item);

                                                  checkboxValues[index] = false;
                                                  if (filteredList.isNotEmpty) {
                                                    final indexOfFiltered =
                                                        filteredList
                                                            .indexOf(item);

                                                    filteredCheckboxValues[
                                                            indexOfFiltered] =
                                                        false;
                                                  }
                                                });
                                                if (diseaseSymptoms
                                                    .userInput.isEmpty) {
                                                  diseaseSymptoms
                                                      .clearUserInput();
                                                } else {
                                                  diseaseSymptoms
                                                      .removeUserInput(item);
                                                }
                                                if (diseaseSymptoms
                                                    .userInput.isEmpty) {
                                                  Get.back();
                                                }
                                              },
                                              child: Icon(Icons.close,
                                                  color: buttonColor),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    );
                  });
                },
              );
            },
            child: Text(
              "View more",
              style: TextStyle(
                  color: buttonColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget showSearchField(DiseaseSymptoms diseaseSymptoms) {
    return searchBar(
        searchController: searchController,
        showClearButton: showClearButton,
        onChanged: (val) {
          if (val.isEmpty) {
            clearSearch();
          } else {
            searchSymptoms(val.replaceAll(RegExp(r' '), '_'), diseaseSymptoms);
          }
        },
        onSubmitted: (val) {
          if (val.isEmpty) {
            clearSearch();
          } else {
            searchSymptoms(val.replaceAll(RegExp(r' '), '_'), diseaseSymptoms);
          }
        },
        onClearPressed: clearSearch);
  }

  void searchSymptoms(String val, DiseaseSymptoms diseaseSymptoms) {
    setState(() {
      showClearButton = val.isNotEmpty;
      filteredList = originalList
          .where((item) => item.toLowerCase().contains(val.toLowerCase()))
          .toList();
      noData = filteredList.isEmpty;
      filteredCheckboxValues = List<bool>.filled(filteredList.length, false);
      for (int i = 0; i < filteredList.length; i++) {
        final originalIndex = originalList.indexOf(filteredList.elementAt(i));
        if (originalIndex != -1) {
          filteredCheckboxValues[i] = checkboxValues[originalIndex];
        }
      }
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      showClearButton = false;
      filteredList.clear();
      noData = false;
    });
  }

  void onCheckBoxClicked(int index, bool value) {
    final diseaseSymptomsVM =
        Provider.of<DiseaseSymptoms>(context, listen: false);
    final selectedSymptom = filteredList.isNotEmpty
        ? filteredList.elementAt(index)
        : diseaseSymptomsVM.totalSymptoms.elementAt(index);

    setState(() {
      if (filteredList.isNotEmpty) {
        filteredCheckboxValues[index] = value;
        final originalIndex = originalList.indexOf(selectedSymptom);
        if (originalIndex != -1) {
          checkboxValues[originalIndex] = value;
        }
      } else {
        final originalIndex = originalList.indexOf(selectedSymptom);
        if (originalIndex != -1) {
          checkboxValues[originalIndex] = value;
        } else {
          originalList.add(selectedSymptom);
          checkboxValues.add(value);
        }
      }
      if (value) {
        diseaseSymptomsVM.userInput.add(selectedSymptom);
      } else {
        diseaseSymptomsVM.userInput.remove(selectedSymptom);
      }
    });
  }
}
