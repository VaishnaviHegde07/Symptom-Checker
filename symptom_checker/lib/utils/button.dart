import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:symptom_checker/utils/colors.dart';

Center cupertinoButton(
        {VoidCallback? onPressed,
        required String title,
        Key? key,
        Color? color}) =>
    Center(
        child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: lightBlue, blurRadius: 5, offset: const Offset(0, 3))
              ]),
              child: CupertinoButton(
                  disabledColor: disbaleButtonColor,
                  color: color ?? disbaleButtonColor,
                  onPressed: onPressed,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: pureWhite,
                    ),
                  )),
            )));
TextButton textButton(
        {VoidCallback? onPressed, required String title, Color? color}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color ?? pureWhite,
        ),
      ),
    );
