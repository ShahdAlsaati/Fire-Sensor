import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/theme_and_color/color.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
         CircleAvatar(
          radius:80.r ,
          backgroundColor: buttonColor,

        ),
        Positioned(
          bottom: 5.h,
          right: 5.w,
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt,
              color:Colors.white,
            ),
            onPressed: () {

            },

          ),

        )
      ],
    );
  }
}
