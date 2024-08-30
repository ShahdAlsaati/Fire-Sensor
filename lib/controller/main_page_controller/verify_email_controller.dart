// ### verify the email
// POST http://localhost:2500/mobile-app/verify-email
// Content-Type: application/json
// Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MTU3NjQ1MDQsImlhdCI6MTcxNTc1ODUwNCwic3ViIjoibW9iaWxlQWNjZXNzIiwidXNlcklkIjoyLCJ1c2VybmFtZSI6Imdlb3JnZSIsImxldmVsIjoidXNlckxldmVsIn0.anPtwf2a1UJCnOoXZhUWh359597-qTNsSzxOFXoBFpY
//
// ### send vcode
// POST http://localhost:2500/mobile-app/send-email-vcode
// Content-Type: application/json
// Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MTU3NjQ1MDQsImlhdCI6MTcxNTc1ODUwNCwic3ViIjoibW9iaWxlQWNjZXNzIiwidXNlcklkIjoyLCJ1c2VybmFtZSI6Imdlb3JnZSIsImxldmVsIjoidXNlckxldmVsIn0.anPtwf2a1UJCnOoXZhUWh359597-qTNsSzxOFXoBFpY
//
// {
// "vcode": "084829"
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/pages/porfile_page/profile_screen.dart';
import 'package:googlemap/pages/signin_screens/code_vertification_screen.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../constants/constants.dart';
import '../../constants/function.dart';
import '../../shared/network/local/cache_helper.dart';

class VerifyEmailController extends GetxController{
  final _apiServer = APIServer();
  GlobalKey<FormState> abcKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  getUserDetails() async {
    String? email = await CacheHelper.getData(key:'email');
    if(email !=null) {
      emailController= TextEditingController(text: email);
    }

  }

  var emailController = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }
  String vVerificationCode='';

  setVertifiyCode(String verificationCode){
    vVerificationCode=verificationCode;
  }

  void sendEmailVerifyCode() async {

    if(isLoading.isTrue) return;
    // start if not started
    isLoading.value = true;

    final r = await _apiServer.sendEmailVerifyCode(vVerificationCode).onError((error, stackTrace) {
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
         callSuccessSnakeBar("Email Verify Successfully");
        isLoading.value = false;
        Get.offAll(() =>  ProfileScreen(isUser: true));
      }
    }
  }


}
class APIServer extends GetConnect {
  /// [sendEmailVerifyCode] -- do verify
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


}