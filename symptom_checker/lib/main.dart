import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:symptom_checker/controllers/check_internet_connection.dart';
import 'package:symptom_checker/utils/colors.dart';
import 'package:symptom_checker/views/symptoms_input.dart';
import 'package:provider/provider.dart';
import 'controllers/disease_symptoms_controller.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: DiseaseSymptoms()),
      ChangeNotifierProvider.value(value: ConnectivityViewModel()),
    ],
    child: const GetMaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScren()),
  ));
}

class SplashScren extends StatefulWidget {
  const SplashScren({Key? key}) : super(key: key);
  @override
  State<SplashScren> createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    return Get.to(() => const SymptomInputScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pureWhite,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/splash.jpg", fit: BoxFit.fill),
              Text(
                "Symptom Checker",
                style: TextStyle(
                    color: purplyblue,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
