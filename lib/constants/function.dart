
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void callSuccessSnakeBar(String success){
  Get.snackbar('success', success,);
}

void errorSnakeBar(String error){
  Get.snackbar('Error', error,
      backgroundColor: Colors.redAccent);
}