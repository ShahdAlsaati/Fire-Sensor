import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/theme_and_color/color.dart';
import '../../controller/signin_controller/foreget_password_controller.dart';
import '../../widget/text_button_widget/button_widget.dart';
import '../../widget/text_button_widget/text_form_field_widget.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  String title;
   ForgetPasswordScreen({super.key,required this.title });

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
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Text("$title",
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


                        TextFormFieldWidget(

                            name: "Name",
                            controller:controller.userNameController,
                            hintText: "Name",
                            inputType: TextInputType.name,
                            function: (value){
                              if(value==null){
                                return 'Please enter valid name ';
                              }
                              else
                              {
                                return null;
                              }
                            }
                        ),


                         SizedBox(
                          height: 50.h,
                        ),
                        Obx(
                              () => ButtonWidget(
                            text: controller.isLoading.isTrue ? "Sending" : "Send",
                            onTap: controller.forgetPassword,
                            color: buttonColor,
                          ),
                        ),

                      ],                    ),
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
