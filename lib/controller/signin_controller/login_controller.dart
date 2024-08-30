import 'dart:convert';
import 'package:googlemap/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/function.dart';
import '../../constants/key.dart';
import '../../pages/layout/home_page.dart';
import '../../shared/network/local/cache_helper.dart';

const baseURL = 'http://192.168.1.4:2500';

class LoginController extends GetxController {
  /// instances
  final _apiServer = APIServer();
  final keyLog = JosKeys();

  // variables
  var isPasswordShow = true.obs;
  var isLoading = false.obs;
  var isLoadingG = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();


  IconData suffix = Icons.visibility_off_outlined.obs.value;

  /// [validateEmail] -- validate email
  String? validateEmail(String? value) {
    if (value == null) return 'email is required';

    if (!value.isEmail) 'Enter a valid email address';
    return null;
  }

  void changePPasswordVisibility() {
    isPasswordShow.value = !isPasswordShow.value;

    suffix = isPasswordShow.value
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
  }

  void login() async {
    // check if fields are validated  - if not cancel login

    try {
      if (JosKeys.loginFormKey.currentState?.validate() == false) return;

      isLoading.value = true;

      final r = await _apiServer.loginWithEmailAndPassword(
        nameController.text.trim(),
        passwordController.text,
      ).onError((error, stackTrace) {
        errorSnakeBar(error.toString());


        // end if an error
        isLoading.value = false;


        return null;
      });

      if (r == null) {
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
            errorMessage = 'No user with username: ${nameController.text}';
          }
         else if (errors is List && errors.contains(300)) {
            errorMessage = 'incorrect password';
          }
        }

        errorSnakeBar(errorMessage);

        isLoadingG.value = false;

        return;

      }
      // انتقل بس اذا كانت حالة الكود 200
      if (r.statusCode == 200) {
        await CacheHelper.saveData(key: 'username',
            value: nameController.text
        );

          await CacheHelper.saveData(key: 'accessToken',
              value: r.body['accessToken'].toString()
          );
          await CacheHelper.saveData(key: 'refreshToken',
              value: r.body['refreshToken'].toString()
          );
          await CacheHelper.saveData(key: 'userId', value: r.body['userId'].toString());

          print('jjjj');
          isLoading.value = false;
          Get.offAll(() =>  HomePage(isUser: true,));

      }
    }catch(e)
    {
      print(e.toString());
    }
  }

  void loginGuest() async {
    try {


      if (isLoadingG.isTrue) return;
      // start if not started
      isLoadingG.value = true;

      final r = await _apiServer.loginAsGuest().onError((error, stackTrace) {
        Get.snackbar(
          'Error',
          '$error',
          backgroundColor: Colors.redAccent,
        );

        // end if an error
        isLoadingG.value = false;


        return null;
      });

      if (r == null) {
        isLoadingG.value = false;

        return;
      }

      // here we'll check if login is successful
      if (r.hasError) {
        isLoadingG.value = false;


        Get.snackbar(
          'Error',
          "${r.body["errors"]??"An unknown error occurred"}",
          backgroundColor: Colors.redAccent,
        );
        isLoadingG.value = false;

        return;
      }
           // انتقل بس اذا كانت حالة الكود 200
      if (r.statusCode == 200) {
        isLoadingG.value = false;

        await CacheHelper.saveData(key: 'guestToken',
            value: r.body['token'].toString()
        );

        isLoading.value = false;
        Get.offAll(() =>  HomePage(isUser: false,));

      }
    }catch(e)
    {
      isLoadingG.value = false;

      print(e.toString());
    }
  }

}

class APIServer extends GetConnect {
  /// [loginWithEmailAndPassword] -- do login
  Future<Response?> loginWithEmailAndPassword(
      String name, String password) async {
    // var url = Uri.parse('http://192.168.1.7:2500/mobile-app/login');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "username": name,
      "password": password,
    });

    try {
      // send post request
      final res = await post(
        '${BASE_URL}login',
        body,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }

  /// [loginAsGuest] -- do login
  Future<Response?> loginAsGuest() async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      // send post request
      final res = await post(
        '${BASE_URL}login/guest',
        headers: headers,
        {}
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }
}
