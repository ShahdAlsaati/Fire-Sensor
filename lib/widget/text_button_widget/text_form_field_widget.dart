import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';


class TextFormFieldWidget extends StatelessWidget {
  final Function(String)? onChange;
  Color?colorIcon;
  String name;
  final TextEditingController controller;
  TextInputType inputType;
  String hintText;
  String? Function(String?)? function;
  IconData? suffix;
  Function? suffixPressed;
  bool isPassword;
  bool multiLine;
  TextFormFieldWidget(
      {super.key,
      required this.name,
      required this.controller,
      required this.hintText,
      required this.inputType,
      required this.function,
      this.multiLine=false,
      this.suffix,
        this.colorIcon,
        this.onChange,
      this.suffixPressed,
      this.isPassword = false,
        });

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
        child: TextFormField(

          obscureText: isPassword,
          textInputAction: TextInputAction.next,
          keyboardType: inputType,
          cursorColor: buttonColor,
          onChanged: (v) {
            if (onChange != null) {
              onChange!(v);
            }
          },
          controller: controller,
          validator: function,

          minLines: multiLine?6:1,
          maxLines: multiLine?6:1,

          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 8.w),

            suffixIcon: suffix != null
                ? IconButton(
                    onPressed: () {
                      suffixPressed!();
                    },
                    icon: Icon(
                      suffix,
                      color:colorIcon??Theme.of(context).iconTheme.color,
                    ),
                  )
                : null,
            hintText: hintText,
            hintStyle:TextStyle(

              color: colorTextInCreatePostAndHintColor,
              fontSize: 13.50.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          fillColor: textFormFieldColor,
          filled: true,

          enabledBorder:   UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: textFormFieldColor),
          ),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: const BorderSide(color: textFormFieldColor),

            ),
            focusedBorder:   UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: const BorderSide(color: textFormFieldColor),
            ),
            errorBorder:   UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: const BorderSide(

                color: Colors.red,

              ),

            ),
          ),
        ),
      );
  }
}
