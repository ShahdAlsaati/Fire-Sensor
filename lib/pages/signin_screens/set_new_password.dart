import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googlemap/controller/signin_controller/set_new_password_controller.dart';

import '../../constants/constants.dart';
import '../../constants/theme_and_color/color.dart';
import '../../widget/text_button_widget/button_widget.dart';
import '../../widget/text_button_widget/text_form_field_widget.dart';

class SetNewPassword extends StatelessWidget {
   SetNewPassword({super.key});
  SetNewPasswordController controller=Get.put(SetNewPasswordController());

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
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Set Your New Password",
                      style:TextStyle(
                        color: Colors.white,
                        fontSize: 40.37.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      )),
                  const SizedBox(
                    height: 15,
                  ),


                  Obx(
                        () => TextFormFieldWidget(
                        suffixPressed: () {
                          controller.changePPasswordVisibility();
                        },
                        suffix: controller.suffix,
                        isPassword: controller.isPasswordShow.value,
                        name: "Password",
                        controller: controller.newPasswordController,
                        hintText: "Password",
                        inputType: TextInputType.visiblePassword,
                        function: (value) {
                          if (controller.newPasswordController.text.isEmpty ||
                              controller.newPasswordController.text.length <
                                  9) {
                            return 'Please enter a valid password (at least 9 characters)';
                          } else {
                            return null;
                          }
                        }),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),
                  Obx(
                        () => TextFormFieldWidget(
                        suffixPressed: () {
                          controller.changePPasswordVisibility2();
                        },
                        suffix: controller.suffix2,
                        isPassword: controller.isPasswordShow2.value,
                        name: "Password",
                        controller: controller.confirmPasswordController,
                        hintText: "Repeat Password",
                        inputType: TextInputType.visiblePassword,
                        function: (value) {
                          if (controller.confirmPasswordController.text !=
                              controller.confirmPasswordController.text) {
                            return 'The password does not match';
                          }
                          return null;
                        }),
                  ),
                  divider(),
                  divider(),
                  divider(),


                  Obx(
                        () => ButtonWidget(
                      text: "send",
                      onTap:(){},
                      color: buttonColor,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
