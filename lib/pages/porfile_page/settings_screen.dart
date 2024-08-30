import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/controller/profile_controller/edit_profile_controller.dart';
import 'package:googlemap/pages/signin_screens/reset_password_screen.dart';

import '../../constants/theme_and_color/color.dart';
import '../../widget/text_button_widget/button_widget.dart';
import '../../widget/text_button_widget/text_form_field_widget.dart';
import '../main_page/verify_e-mail_screen.dart';
import '../signin_screens/foreget_password_screen.dart';
import 'fire_safety_screen.dart';

class SettingsProfileScreen extends StatelessWidget {

  final SettigsProfileController controller=Get.put(SettigsProfileController());

  SettingsProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios
          ),
          onPressed: (){
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: backgroundColor,

      ),

      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                ButtonWidget(
                  text: controller.isLoading.isTrue?"Verifying":"Verify",
                  onTap: controller.askForCodeVerify,


                  color: buttonColor,),
                divider(),
                divider(),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(

                      onPressed: (){
                        // Get.find<VerifyEmailController>().askForCodeVerify();
                        Get.to(()=>ForgetPasswordScreen(title: "Forget Password",));
                      }, child: const Text(
                    'reset password',
                    style: TextStyle(
                        color: postConstTextColor
                    ),
                  )),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
