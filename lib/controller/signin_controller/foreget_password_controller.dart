import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/constants/function.dart';
import 'package:googlemap/pages/signin_screens/reset_password_screen.dart';
import 'package:googlemap/shared/network/local/cache_helper.dart';

import '../../constants/constants.dart';


class ForgetPasswordController extends GetxController{

  final  formKey=GlobalKey<FormState>();
  var userNameController= TextEditingController(text: '');


  /// instances
  final _apiServer = APIServer();

  // variables
  var isLoading = false.obs;



  void forgetPassword() async {
    // check if fields are validated  - if not cancel login
    if (formKey.currentState?.validate() == false) return;

    // make sure is only executes once and wait until it completes

    if(isLoading.isTrue) return;
    // start if not started
    isLoading.value = true;

    final r = await _apiServer.forgetPasswordWithEmail(
      userNameController.text.trim(),
    ).onError((error, stackTrace) {
      Get.snackbar(
        'Error',
        '$error',
        backgroundColor: Colors.redAccent,
      );

      // end if an error
      isLoading.value = false;


      return null;
    });

    if(r ==null) {
      return;
    }

    // here we'll check if login is successful
    if (r.hasError) {
      isLoading.value = false;

      var errorMessage = 'An unknown error occurred';
      if (r.body is Map && r.body.containsKey('codes')) {
        var errors = r.body['codes'];
        print("errors: $errors");

        // Check if the error list contains the code 1
        if (errors is List && errors.contains(1)) {
          errorMessage = 'No user with username: ${userNameController.text}';
        }

      }

     errorSnakeBar(errorMessage);

      return;

    }
    // انتقل بس اذا كانت حالة الكود 200
    if( r.statusCode == 200) {
      // تحقق مره ثانية اذا كان في خطأ جاي من الباك
      if (r.body['message']=='success') {
        // end
        await CacheHelper.saveData(key: 'userName', value: userNameController.text);
        isLoading.value = false;
        Get.snackbar(
          'success',
          '${r.body['message']}',
          backgroundColor: Colors.white10,
        );

        Get.to(()=>ResetPasswordScreen());
      }
    }
  }

}

class APIServer extends GetConnect {
  /// [forgetPasswordWithEmail] -- do login
  Future<Response?> forgetPasswordWithEmail(
      String username) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "username": username
    });

    try {
      // send post request
      final res = await post(
        '${BASE_URL}forgot-password',
        body,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }
}
