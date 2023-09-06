import 'package:flutter/material.dart';
import 'package:symptom_checker/utils/colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgressBar extends StatelessWidget {
  final double progressPercentage;

  const CircularProgressBar({
    Key? key,
    required this.progressPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double containerSize = 90.0;
    const double radius = containerSize / 3;

    return Center(
      child: SizedBox(
        width: containerSize,
        height: 100,
        child: CircularPercentIndicator(
          radius: radius,
          lineWidth: radius / 5,
          animation: true,
          percent: progressPercentage / 100,
          center: Text(
            '${progressPercentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: progressPercentage <= 25
                  ? successColor
                  : progressPercentage <= 75
                      ? holdColor
                      : progressPercentage > 75
                          ? warningColor
                          : holdColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          progressColor: progressPercentage <= 25
              ? successColor
              : progressPercentage <= 75
                  ? holdColor
                  : progressPercentage > 75
                      ? warningColor
                      : holdColor,
          backgroundColor: const Color.fromARGB(255, 196, 210, 208),
          rotateLinearGradient: true,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ),
    );
  }
}
