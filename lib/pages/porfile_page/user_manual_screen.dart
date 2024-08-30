import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widget/profile_widget/user_manual_widget.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Manual'),
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },),

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 15.h,),
        
            UserManualWidget(
              url: "assets/final_icon/activeAndBig.png",
              dis: "Fire is Large/Extreme",
              width: 80,
              height: 80,
            ),
            SizedBox(height: 15.h,),
            UserManualWidget(
              url: "assets/final_icon/activeAndMid.png",
              dis: "Fire is Big",
              width: 80,
              height: 80,
            ),
            SizedBox(height: 15.h,),

            UserManualWidget(
              url: "assets/final_icon/activeAndSmall.png",
              dis: "Fire is Mid",
              width: 80,
              height: 80,
            ),
            SizedBox(height: 15.h,),
        
            UserManualWidget(
              url: "assets/final_icon/activeAndVerySmall.png",
              dis: "Fire is Small",
              width: 80,
              height: 80,
            ),
            SizedBox(height: 15.h,),

            UserManualWidget(
              url: "assets/final_icon/nonActive.png",
              dis: "Fire is not active",
              width: 80,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
