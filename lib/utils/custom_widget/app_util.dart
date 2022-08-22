import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maybank_todo/utils/app_color.dart';

AppBar getAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(title),
    backgroundColor: AppColor.themeColor,
    foregroundColor: AppColor.themeBlack,
    actions: actions,
  );
}

String generateUUID() => DateTime.now().microsecondsSinceEpoch.toString();

void showSnackBar(String title, String message) {
  Get.showSnackbar(GetSnackBar(
    title: title,
    message: message,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    duration: const Duration(seconds: 2),
  ));
}

Future<bool?> showConfirmation(String title, String message) {
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Get.back(result: false);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Ok"),
    onPressed: () {
      Get.back(result: true);
    },
  );

  return Get.dialog<bool>(AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  ));
}
