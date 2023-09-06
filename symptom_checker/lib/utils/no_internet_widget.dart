import 'package:flutter/material.dart';
import 'package:symptom_checker/utils/colors.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            child: Image.asset(
              'assets/images/noInternet2.png',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Check your connection and try again",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: purplyblue,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
