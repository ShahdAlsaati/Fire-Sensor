import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  String text;
  final VoidCallback? onTap;
  Color color;

  ButtonWidget({super.key, required this.text,required this.onTap,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      width: MediaQuery.of(context).size.width*0.94,

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),

      ),
      child: MaterialButton(
        onPressed:onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,

          ),
        ),
      ),
    );
  }
}
