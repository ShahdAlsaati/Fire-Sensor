import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/pages/signin_screens/login_screen.dart';
import 'package:googlemap/widget/text_button_widget/button_widget.dart';
import 'package:googlemap/widget/text_button_widget/text_form_field_widget.dart';
import '../../constants/key.dart';
import '../../controller/signin_controller/register_controller.dart';

class SignUpScreen extends GetView<RegisterController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.string(arrowBackIcon),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: 5,
                    left: 5,
                    child: SvgPicture.asset('assets/background.svg'),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: JosKeys.signUpFormKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.37.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flexible(
                                child: Obx(
                                      () => TextFormFieldWidget(
                                    colorIcon: controller.isUsernameAvailable.value
                                        ? Colors.red
                                        : Colors.green,
                                    suffix: controller.isUsernameAvailable.value
                                        ? Icons.close
                                        : Icons.check,
                                    onChange: (value) {
                                      controller.checkUsernameAvailability(value);
                                    },
                                    name: "Name",
                                    controller: controller.nameController,
                                    hintText: "name",
                                    inputType: TextInputType.name,
                                    function: (value) {
                                      if (value == null) return 'field is required';
                                      if (value.isEmpty) {
                                        return "Name cannot be null";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flexible(
                                child: TextFormFieldWidget(
                                  name: "E-mail",
                                  controller: controller.emailController,
                                  hintText: "E-mail",
                                  inputType: TextInputType.emailAddress,
                                  function: (value) {
                                    if (value == null ||
                                        !(controller.emailController.text
                                            .contains('@'))) {
                                      return 'Please enter valid email address';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flexible(
                                child: Obx(
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
                                      if (controller.passwordController.text.isEmpty ||
                                          controller.passwordController.text.length <8) {
                                        return 'Please enter a valid password (at least 8 characters)';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flexible(
                                child: Obx(
                                      () => TextFormFieldWidget(
                                    suffixPressed: () {
                                      controller.changePPasswordVisibility2();
                                    },
                                    suffix: controller.suffix2,
                                    isPassword: controller.isPasswordShow2.value,
                                    name: "Password",
                                    controller: controller.repeatPasswordController,
                                    hintText: "Repeat Password",
                                    inputType: TextInputType.visiblePassword,
                                    function: (value) {
                                      if (controller.passwordController.text !=
                                          controller.repeatPasswordController.text) {
                                        return 'The password does not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45.h,
                              ),
                              Flexible(
                                child: Obx(
                                      () => ButtonWidget(
                                    text: controller.isLoading.isTrue
                                        ? "Signing up"
                                        : "Sign up",
                                    onTap: controller.signUp,
                                    color: buttonColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Flexible(
                                child: ButtonWidget(
                                  text: "Login",
                                  onTap: () async {
                                    Get.to(() => const LoginScreen());
                                  },
                                  color: textFormFieldColor,
                                ),
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
          ),
        ),
      ),
    );
  }

}
