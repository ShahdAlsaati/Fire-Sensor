import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../constants/function.dart';
import '../../pages/signin_screens/code_vertification_screen.dart';
import '../../shared/network/local/cache_helper.dart';

class SettigsProfileController extends GetxController{

  final _apiServer = APIServer();

  var isLoading = false.obs;
  //  getUserDetails() async {
  //
  //   String? name = await CacheHelper.getData(key: 'username');
  //   String? email = await CacheHelper.getData(key: 'email');
  //   if(name !=null) {
  //     nameController= TextEditingController(text: name);
  //   }
  //   if(email !=null) {
  //     emailController= TextEditingController(text: email);
  //   }
  //
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getUserDetails();
  }
  void askForCodeVerify() async {

  final isEmailVerified=  await CacheHelper.getData(key: 'emailVerified');

  if(isEmailVerified!=null&&isEmailVerified==true)
    {
      errorSnakeBar('your email is already verify');
      return;
    }

    if(isLoading.isTrue) return;
    // start if not started
    isLoading.value = true;

    final r = await _apiServer.askForCodeVerify( ).onError((error, stackTrace) {
      errorSnakeBar(error.toString());

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
      if (r.body is Map && r.body.containsKey('message')) {
        var message = r.body['message'];
        print("Full error message: $message");

        // Extract the part of the message related to email already existing
        if (message is String && message.contains('email')) {
          // Split the message by ":" and take the last part
          var parts = message.split(':');
          if (parts.length > 3) {
            // Combine the relevant parts to form the final message
            errorMessage = '${parts[2].trim()}: ${parts[3].trim()}';
          }
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
        callSuccessSnakeBar("Code Send Successfully , please check your email");
        isLoading.value = false;


        Get.to(()=>CodeVertificationScreen());


      }
    }
  }

}
class APIServer extends GetConnect {

  /// [askForCodeVerify] -- do ask for send code for email

  Future<Response?> askForCodeVerify() async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':'Bearer ${CacheHelper.getData(key: 'accessToken')}',

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