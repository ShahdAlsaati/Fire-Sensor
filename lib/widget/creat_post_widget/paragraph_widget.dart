import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';

class ParagraphWidget extends StatelessWidget {
TextEditingController controller;
ParagraphWidget({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: textFormFieldColor,
        borderRadius:BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black, // Specify the color here
          width: 1.0, // Specify the width of the border
        ),
      ),
      height: 210.h,
      width: 600.w,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,

          style: const TextStyle(color: Colors.white),

          maxLines: null, // Allows for multiple lines
          keyboardType: TextInputType.multiline,
          validator: (v){
            if(v==null)
              return 'errrror';

            return null;
          },
          decoration:  InputDecoration(

            hintText: 'Write your post here',
            hintStyle: TextStyle(
            color:colorFeelingDis ,
            fontSize: 15.24.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),

          enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: textFormFieldColor)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: textFormFieldColor)),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),

        ),
      ),

    );
  }
}
