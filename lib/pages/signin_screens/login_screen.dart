import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/pages/signin_screens/foreget_password_screen.dart';
import 'package:googlemap/pages/signin_screens/signin_screen.dart';
import 'package:googlemap/widget/text_button_widget/button_widget.dart';
import 'package:googlemap/widget/text_button_widget/text_form_field_widget.dart';
import '../../constants/key.dart';
import '../../controller/signin_controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        elevation: 0,
        backgroundColor: backgroundColor,

        actions: [
          Obx(
                () => TextButton(
                  onPressed: controller.loginGuest,
                  child:  Text(
                     controller.isLoadingG.isTrue ? "skipping" : "skip",
                    style: const TextStyle(
                        color: textColor
                    ),
                  ),

                ),

          ),

        ],
      ),

      backgroundColor: backgroundColor,

      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                right: 5,
                left: 5,
                // bottom: 0,
                child: SvgPicture.asset('assets/background.svg')),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: JosKeys.loginFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Have Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.37.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                         SizedBox(
                          height: 15.h,
                        ),
                        TextFormFieldWidget(
                          name: "Name",
                          controller: controller.nameController,
                          hintText: "name",
                          inputType: TextInputType.name,
                          function: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name cannot be null";
                            }
                            return null;
                          },
                        ),
                         SizedBox(
                          height: 15.h,
                        ),
                        Obx(
                              () => TextFormFieldWidget(
                            suffixPressed: () {
                              controller.changePPasswordVisibility();
                            },
                            suffix: controller.suffix,
                            isPassword: controller.isPasswordShow.value,
                            name: "Password",
                            controller: controller.passwordController,
                            hintText: "Password",
                            inputType: TextInputType.visiblePassword,
                            function: (value) {
                              if (value == null || value.isEmpty || value.length < 8) {
                                return 'Please enter a valid password';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                         SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() =>  ForgetPasswordScreen(title: "Forget Password",));
                                },
                                child: const Text(
                                  'Forget password?',
                                  style: TextStyle(color: buttonColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                         SizedBox(
                          height: 15.h,
                        ),
                        Obx(
                              () => ButtonWidget(
                            text: controller.isLoading.isTrue ? "Logging" : "Login",
                            onTap: controller.login,
                            color: buttonColor,
                          ),
                        ),
                         SizedBox(
                          height: 15.h,
                        ),
                        ButtonWidget(
                          text: "Sign up",
                          onTap: () {
                            Get.to(() => const SignUpScreen());
                          },
                          color: textFormFieldColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
