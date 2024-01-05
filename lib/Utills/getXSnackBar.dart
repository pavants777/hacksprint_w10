import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController GetXSnackbar(String title, message) {
  return Get.snackbar(title, message,
      duration: Duration(seconds: 5),
      dismissDirection: DismissDirection.horizontal,
      isDismissible: true);
}
