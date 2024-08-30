import 'dart:convert';

import "package:get/get.dart";
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../shared/network/local/cache_helper.dart';
class SetNewPasswordController extends GetxController{
  var confirmPasswordController= TextEditingController(text: '');

  var newPasswordController= TextEditingController(text: '');
  final  formKey=GlobalKey<FormState>();
  var isPasswordShow = true.obs;

  IconData suffix = Icons.visibility_off_outlined.obs.value;
  final _apiServer = APIServer();

  var isLoading = false.obs;

  void changePPasswordVisibility() {
    isPasswordShow.value = !isPasswordShow.value;

    suffix = isPasswordShow.value ? Icons.visibility_off_outlined : Icons
        .visibility_outlined;
  }

  var isPasswordShow2 = true.obs;

  IconData suffix2 = Icons.visibility_off_outlined.obs.value;

  void changePPasswordVisibility2() {
    isPasswordShow2.value = !isPasswordShow2.value;

    suffix2 = isPasswordShow2.value ? Icons.visibility_off_outlined : Icons
        .visibility_outlined;
  }


  void resetPassword(String vcode, String password) async {
    // check if fields are validated  - if not cancel login
    if (formKey.currentState?.validate() == false) return;

    if(isLoading.isTrue) return;
    // start if not started
    isLoading.value = true;

    final r = await _apiServer.SetNewPassword( vcode,  password).onError((error, stackTrace) {
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
      // end if an error
      isLoading.value = false;
      Get.snackbar(
        'Error',
        '${r.body}',
        backgroundColor: Colors.redAccent,
      );
    }
    // انتقل بس اذا كانت حالة الكود 200
    if( r.statusCode == 200) {
      // تحقق مره ثانية اذا كان في خطأ جاي من الباك
      if (r.body['message']=='success') {
        // end

        print(r.body['id']);
        isLoading.value = false;
      }
    }
  }


}
class APIServer extends GetConnect {
  /// [SetNewPassword] -- do sign up
  Future<Response?> SetNewPassword(
      String vcode, String password,) async {
    String? userId = await CacheHelper.getData(key: 'userId');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "vcode": vcode,
      "password": password
    });

    try {
      // send post request
      final res = await post(
        '$BASE_URL/$userId/reset-password',
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
