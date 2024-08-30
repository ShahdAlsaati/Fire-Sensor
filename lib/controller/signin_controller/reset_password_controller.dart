/*### reset it
POST http://localhost:2500/mobile-app/reset-password
Content-Type: application/json

{
  "vcode": "506162",
  "password": "georgeis12345",
  "username": "george"
}*/

import 'dart:convert';

import "package:get/get.dart";
import 'package:flutter/material.dart';
import 'package:googlemap/pages/signin_screens/login_screen.dart';
import '../../constants/constants.dart';
import '../../shared/network/local/cache_helper.dart';
class ResetPasswordController extends GetxController{
  var repeatPasswordController = TextEditingController();

  var userNameController= TextEditingController();
  var newPasswordController= TextEditingController();
  var vCodeController= TextEditingController();
  getUserDetails() async {
    String? userName = await CacheHelper.getData(key: 'userName');
    if(userName !=null) {
      userNameController= TextEditingController(text: userName);
    }

  }
  var isPasswordShow2 = true.obs;

  IconData suffix2 = Icons.visibility_off_outlined.obs.value;

  void changePPasswordVisibility2() {
    isPasswordShow2.value = !isPasswordShow2.value;

    suffix2 = isPasswordShow2.value ? Icons.visibility_off_outlined : Icons
        .visibility_outlined;
  }

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

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }


  void resetPassword() async {
    // check if fields are validated  - if not cancel login
    if (formKey.currentState?.validate() == false) return;


    if(isLoading.isTrue) return;
    // start if not started
    isLoading.value = true;

    final r = await _apiServer.resetPasswordWithEmailAndPassword(
     username: userNameController.text,
      password:  newPasswordController.text,
      vcode: vCodeController.text,

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

        isLoading.value = false;
        Get.snackbar(
          'Success',
          '${r.body}',
          backgroundColor: Colors.green,
        );
        Get.to(()=>const LoginScreen());

      }
    }
  }


}
class APIServer extends GetConnect {

  /// [resetPasswordWithEmailAndPassword] -- do reset
  Future<Response?> resetPasswordWithEmailAndPassword(
      {required String username,required String password,required String vcode}) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "username": username,
      "password": password,
      "vcode":vcode
    });

    try {
      // send post request
      final res = await post(
        '${BASE_URL}reset-password',
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
