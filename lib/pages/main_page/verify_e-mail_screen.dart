import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../constants/theme_and_color/color.dart';
import '../../controller/main_page_controller/verify_email_controller.dart';
import '../../widget/text_button_widget/button_widget.dart';
import '../../widget/text_button_widget/text_form_field_widget.dart';

class VerifyYourEmailScreen extends StatelessWidget {
  final verifyYourEmailController=Get.put(VerifyEmailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:FutureBuilder(
        future:verifyYourEmailController.getUserDetails() ,
        builder: (context,snapshot){
          return Form(
            key: verifyYourEmailController.abcKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                divider(),
                TextFormFieldWidget(

                    name: "Email",
                    controller: verifyYourEmailController.emailController,
                    hintText: "Email",
                    inputType: TextInputType.emailAddress,
                    function: (value){
                      if(value==null|| !(verifyYourEmailController.emailController.text.contains('@'))){
                        return 'Please enter valid email address';
                      }
                      else
                      {
                        return null;
                      }
                    }
                ),


              ],
            ),
          );
        },
      )

    );
  }
}
