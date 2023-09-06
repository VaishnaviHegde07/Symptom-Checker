import 'package:flutter/cupertino.dart';
import 'package:symptom_checker/utils/colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: buttonColor),
        borderRadius: BorderRadius.circular(10),
        color: pureWhite,
      ),
      child: child,
    );
  }
}
