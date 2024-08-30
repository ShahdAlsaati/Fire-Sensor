import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/constants.dart';
import '../../constants/function.dart';
import '../../shared/network/local/cache_helper.dart';
import 'package:geolocator/geolocator.dart';

class CodeVertifyController extends GetxController {
  final _apiServer = APIServer();

  Position? position;

  var isLoading = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var repeatPasswordController = TextEditingController();

  var isPasswordShow = true.obs;

  IconData suffix = Icons.visibility_off_outlined.obs.value;

  void changePPasswordVisibility() {
    isPasswordShow.value = !isPasswordShow.value;

    suffix = isPasswordShow.value ? Icons.visibility_off_outlined : Icons
        .visibility_outlined;
  }
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var isPasswordShow2 = true.obs;

  IconData suffix2 = Icons.visibility_off_outlined.obs.value;

  void changePPasswordVisibility2() {
    isPasswordShow2.value = !isPasswordShow2.value;

    suffix2 = isPasswordShow2.value ? Icons.visibility_off_outlined : Icons
        .visibility_outlined;
  }


  getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentLocation();
    // askForCode();
  }

  var vVerificationCode = ''; // Ensure this variable is initialized

  void setVerifyCode(String verificationCode) {
    vVerificationCode = verificationCode;
  }

  void sendEmailVerifyCode() async {
    if (isLoading.isTrue) return;

    isLoading.value = true;

    final r = await _apiServer.sendEmailVerifyCode(vVerificationCode).onError((error, stackTrace) {
      Get.snackbar(
        'Error',
        'An unknown error occurred',
        backgroundColor: Colors.redAccent,
      );

      isLoading.value = false;
      return null;
    });

    if (r == null) {
      return;
    }

    if (r.hasError) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        "${r.body}",
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    if (r.statusCode == 200 && r.body['message'] == 'success') {
      isLoading.value = false;
      if (r.body['result'] == true) {
        callSuccessSnakeBar('Verification successful!');}
     else {
       errorSnakeBar('Verification failed. Please enter correct code.');
    }

    } else {
      isLoading.value = false;
      errorSnakeBar('Verification failed');

    }
  }



  void askForCode() async {

    // start if not started
    isLoading.value = true;

    final r = await _apiServer.askForCode( ).onError((error, stackTrace) {
      errorSnakeBar('Verification failed. Please try again .');


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
      errorSnakeBar(r.body);

    }
    // انتقل بس اذا كانت حالة الكود 200
    if( r.statusCode == 200) {
      // تحقق مره ثانية اذا كان في خطأ جاي من الباك
      if (r.body['message']=='success') {
        print('success');
        Get.back();


      }
    }
  }

}
class APIServer extends GetConnect {
  /// [sendEmailVerifyCode] -- do sign up
  Future<Response?> sendEmailVerifyCode(String vcode) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',

    };
    var body={
      "vcode": vcode
    };

    try {
      // send post request
      final res = await post(
        '${BASE_URL}send-email-vcode',
        headers: headers,
        body
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }
  Future<Response?> askForCode() async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',

    };


    try {
      // send post request
      final res = await post(
          '${BASE_URL}verify-email',
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