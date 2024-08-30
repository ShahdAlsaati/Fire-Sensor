import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/controller/signin_controller/code_vertification_controller.dart';
import 'package:googlemap/widget/text_button_widget/button_widget.dart';

class CodeVertificationScreen extends StatelessWidget {
  const CodeVertificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final codeVerifyController = Get.put(CodeVertifyController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please Enter Your Code Verification',
              style: TextStyle(fontSize: 25.sp),
            ),
            SizedBox(height: 30.h),
            OtpTextField(
              numberOfFields: 6,
              borderColor: buttonColor,
              focusedBorderColor: buttonColor,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // You can add validation or checks here
              },
              onSubmit: (String verificationCode) {
                // Set the verification code in the controller
                codeVerifyController.setVerifyCode(verificationCode);

                // Send the code to the server
                codeVerifyController.sendEmailVerifyCode();
              }, // end onSubmit
            ),
            SizedBox(height: 30.h),
            ButtonWidget(
              text: 'Send Code',
              onTap: () {
                codeVerifyController.sendEmailVerifyCode();
              },
              color: buttonColor,
            ),
          ],
        ),
      ),
    );
  }
}
