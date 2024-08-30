import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/theme_and_color/color.dart';
import '../../pages/signin_screens/login_screen.dart';

class GuestWidget extends StatelessWidget {
  const GuestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100.h,),
          const Text("You have to login"),
          TextButton(onPressed: (){
            Get.to(()=>const LoginScreen());
          }, child: const Text('Login',
            style: TextStyle(
                color: buttonColor
            ),
          ),

          ),
        ],
      ),
    );

  }
}
