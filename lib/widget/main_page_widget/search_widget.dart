import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/icon/icons_svg.dart';
import '../../constants/theme_and_color/color.dart';

class SearchWidget extends StatelessWidget {
  final Function(String)? onFieldSubmitted;

  SearchWidget({super.key, required this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: textFormFieldColor,
        border: Border.all(color: Colors.black),
      ),
      width: 330.w,
      child: Padding(
        padding: EdgeInsets.only(left: 18.0.w,right: 18.0.w, top: 7.h),
        child: TextFormField(
          textInputAction: TextInputAction.go,
          onFieldSubmitted: (v) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted!(v);
            }
          },
          decoration: InputDecoration(
            icon: SvgPicture.string(searchIcon),
            hintText: "Search",
            hintStyle: TextStyle(
              color: colorTextInCreatePostAndHintColor,
              fontSize: 13.50.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: textFormFieldColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: textFormFieldColor),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
