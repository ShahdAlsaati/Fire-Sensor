import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';

class SortFireButton extends StatelessWidget {
  String icon;
  String text;
   SortFireButton({super.key,required this.text,required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: textFormFieldColor
      ),
      child: Padding(
        padding:  EdgeInsets.only(top: 8.0.h, bottom: 8.0.h,
            left: 10.0.w, right: 10.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(
              icon,
            ),
             SizedBox(
              width: 8.w,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
