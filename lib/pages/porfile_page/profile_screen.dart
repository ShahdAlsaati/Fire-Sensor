import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import 'package:googlemap/controller/profile_controller/profile_controller.dart';
import 'package:googlemap/pages/main_page/verify_e-mail_screen.dart';
import 'package:googlemap/pages/porfile_page/my_post_screen.dart';
import 'package:googlemap/pages/porfile_page/terms_of_use_screen.dart';
import 'package:googlemap/pages/porfile_page/fire_safety_screen.dart';
import 'package:googlemap/pages/porfile_page/user_manual_screen.dart';
import 'package:googlemap/pages/signin_screens/login_screen.dart';
import 'package:googlemap/widget/guest/guest_widget.dart';
import 'package:googlemap/widget/local/loading_circle_widget.dart';
import 'package:googlemap/widget/text_button_widget/button_widget.dart';

import '../../constants/constants.dart';
import 'settings_screen.dart';


class ProfileScreen extends StatelessWidget {

    bool isUser;

   ProfileScreen({super.key,required this.isUser});
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController=Get.put(ProfileController());


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          isUser? IconButton(onPressed: () async {
            Get.to(()=>SettingsProfileScreen());

          },
              icon: const Icon(Icons.settings)):Container(),
        ],


      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<ProfileController>(
              init: ProfileController(),
              builder: (controller) {
                return FutureBuilder(
                    future: profileController.getUserDetails(),
                    builder: (context,snapshot){
        
                      print("Connection State: ${snapshot.connectionState}");
                      print("Has Data: ${snapshot.hasData}");
                      if(snapshot.connectionState==ConnectionState.waiting)
                      {
                        return  const LoadingWidget();
                      }
                      else {
                        List<String>? userDetails = snapshot.data;
                        if(userDetails![0].isNotEmpty||userDetails[3].isNotEmpty||userDetails[4].isNotEmpty){
                          return   Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Stack(
                                      children:<Widget> [
                                         CircleAvatar(
                                          radius:70,
        
                                          backgroundColor: postConstTextColor,
                                          child: SvgPicture.string(
                                            personIcon,width: 70.w,
                                            height: 70.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ) ,
                                  divider(),
                                  Text(userDetails[1],style: TextStyle(
                                    fontSize: 18.sp
                                  ),),
                                  divider(),
                                  Text(userDetails[2],style: TextStyle(
                                      fontSize: 16.sp
                                  ),),
        
        
                                ],
                              ),
                            ),
                          );}
                        else {
        
                          return const GuestWidget();
                        }
        
                      }
        
                    }
        
        
        
        
                );
              },
            ),
            divider(),
            divider(),
            divider(),
            divider(),

          isUser?  ButtonWidget(text: "Show my post",
                onTap: (){
                  Get.to(()=> MyPostScreen(isUser: isUser,));
                },
                color: buttonColor):Container(),
            divider(),
            divider(),
        
            ButtonWidget(text: "Fire Safety Tips",
                onTap: (){
                  Get.to(()=> FairSafetyScreen());
                },
                color: buttonColor),
            divider(),
            divider(),
            ButtonWidget(text: "User Manual",
                onTap: (){
                  Get.to(()=> UserManualScreen());
                },
                color: buttonColor),
            divider(),
            divider(),

            ButtonWidget(text: "Terms of Use",
                onTap: (){
                  Get.to(()=> TermsOfUseContent());
        
                },
                color: buttonColor),
            divider(),
            divider(),

            // isUser? ButtonWidget(text: "Verify Your E-mail ",
            //     onTap: (){
            //       Get.to(()=> VerifyYourEmailScreen());
            //
            //     },
            //     color: buttonColor):Container(),
            // divider(),
            // divider(),
        
            ButtonWidget(text: "Exit",
                onTap: () async {
                 await logout();
                  Get.offAll(()=>const LoginScreen());
        
                },
                color: buttonColor),
          ],
        ),
      ),




    );
  }


}
