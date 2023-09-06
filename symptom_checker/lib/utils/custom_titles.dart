import 'package:flutter/material.dart';
import 'package:symptom_checker/utils/colors.dart';

class Heading extends StatelessWidget {
  final String title;
  const Heading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: purplyblue, fontSize: 24, fontWeight: FontWeight.bold));
  }
}

class Subheading extends StatelessWidget {
  final String title;
  const Subheading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(color: purplyblue, fontSize: 16),
    );
  }
}
