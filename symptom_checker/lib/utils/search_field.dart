import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:symptom_checker/utils/colors.dart';

TextField searchBar({
  required TextEditingController? searchController,
  required void Function(String)? onChanged,
  required void Function(String)? onSubmitted,
  required void Function()? onClearPressed,
  required bool showClearButton,
}) {
  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  void handleSearchQuery(String val) {
    debouncer.call(() {
      onChanged?.call(val);
    });
  }

  return TextField(
    autofocus: false,
    controller: searchController,
    cursorColor: greyColor,
    onChanged: handleSearchQuery,
    onSubmitted: onSubmitted,
    decoration: InputDecoration(
      fillColor: backgroundColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      hintText: "search for symptoms...",
      hintStyle: TextStyle(color: greyColor, fontSize: 16),
      prefixIcon: Container(
          padding: const EdgeInsets.all(15),
          width: 18,
          child: Icon(
            CupertinoIcons.search_circle_fill,
            color: greyColor,
          )),
      suffixIcon: showClearButton
          ? IconButton(
              icon: Icon(Icons.cancel, color: greyColor, size: 24),
              splashColor: pureWhite,
              onPressed: onClearPressed,
            )
          : null,
    ),
  );
}
