import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/pages/layout/home_page.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../constants/function.dart';
import '../../constants/key.dart';
import '../../shared/network/local/cache_helper.dart';
import 'package:geolocator/geolocator.dart';

class RegisterController extends GetxController {
  final _apiServer = APIServer();
  Position? position;
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var repeatPasswordController = TextEditingController();

  getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Error',
          'you cannot sign-up '
              'please give us accesses to your location',
          backgroundColor: Colors.redAccent,
        );
        print("رفض");
      }
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location is off');

        // Ask the user to turn on location services
        bool userTurnedOnLocation = await Geolocator.openLocationSettings();

        if (!userTurnedOnLocation) {
          Get.snackbar(
            'Error',
            'you cannot sign-up '
                'please turn on location',
            backgroundColor: Colors.redAccent,
          );
          print('User did not turn on location');
          return;
        }
      } else {
        print('Location is on');
      }


    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      print('Location permission granted');

      try {
        position = await Geolocator.getCurrentPosition(
          // desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        print('Error getting location: $e');
        return;
      }

      print('////////////////////////////////');
      print('Latitude: ${position!.latitude}');
      print('Longitude: ${position!.longitude}');
      print('Accuracy: ${position!.accuracy}');
      print('-------------------------------------');
    }
    update();
  }


  var isPasswordShow = true.obs;

  IconData suffix = Icons.visibility_off_outlined.obs.value;

  void changePPasswordVisibility() {
    isPasswordShow.value = !isPasswordShow.value;

    suffix = isPasswordShow.value ? Icons.visibility_off_outlined : Icons
        .visibility_outlined;
  }

  final keyLog = JosKeys();

  var isPasswordShow2 = true.obs;

  IconData suffix2 = Icons.visibility_off_outlined.obs.value;

  void changePPasswordVisibility2() {
    isPasswordShow2.value = !isPasswordShow2.value;

    suffix2 = isPasswordShow2.value ? Icons.visibility_off_outlined : Icons
        .visibility_outlined;
  }

  var isUsernameAvailable = false.obs;

  void checkUsernameAvailability(String username) async {
    final response = await _apiServer.checkUsername(username);
    if (response != null && response.statusCode == 200) {
      print('API Response: ${response.body}');
      isUsernameAvailable.value = response.body['result'] ?? false;
    } else {
      isUsernameAvailable.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentLocation();
  }

  void signUp() async {
    // check if fields are validated  - if not cancel login
    if (JosKeys.signUpFormKey.currentState?.validate() == false) return;

    if(isUsernameAvailable.value){
      errorSnakeBar("The user name is already taken");
      return;
    }

    if(isLoading.isTrue) return;
    // start if not started
    isLoading.value = true;

    final r = await _apiServer.signUpWithEmailNAmeAndPassword(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
        position!.latitude,
       position!.longitude

    ).onError((error, stackTrace) {

      errorSnakeBar("$error");


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

       if (errors is List && errors.contains(209)) {
          errorMessage = 'email : ${emailController.text} is already exists';
        }
        if (errors is List && errors.contains(210)) {
          errorMessage = 'user name is already exists';
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.redAccent,
      );
      isLoading.value = false;
      return;
    }
    // انتقل بس اذا كانت حالة الكود 200
    if( r.statusCode == 200) {
      // تحقق مره ثانية اذا كان في خطأ جاي من الباك
      if (r.body['message']=='success') {
        // end
        await CacheHelper.saveData(key: 'userId',
            value: r.body['id'].toString()
        );
        await CacheHelper.saveData(key: 'refreshToken',
            value: r.body['credentials']['MOBILE_REFRESH'].toString()
        );
        await CacheHelper.saveData(key: 'accessToken',
            value: r.body['credentials']['MOBILE_ACCESS'].toString()
        );

        await CacheHelper.saveData(key: 'username',
            value:nameController.text
        );
        await CacheHelper.saveData(key: 'email',
            value:emailController.text
        );
        print(r.body['id']);
        isLoading.value = false;
        // askForCodeVerify();
        Get.offAll(() =>  HomePage(isUser: true,));
      }
    }
  }



}
class APIServer extends GetConnect {
  /// [signupWithEmailAndPassword] -- do sign up
  Future<Response?> signUpWithEmailNAmeAndPassword(
      String name,String email, String password,
      double latitude,double longitude,) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "username": name,
      "email": email,
      "password": password,
      "coordinates": {
        "latitude": latitude,
        "longitude": longitude
      },
      "performLoginOnSuccessfulRegister": true
    });

    try {
      // send post request
      final res = await post(
        '${BASE_URL}sign-up',
        body,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }

  Future<Response?> checkUsername(String username) async {
    try {
      final res = await get('${BASE_URL}sign-up/check-username?username=$username');
      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }
}
