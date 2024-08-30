import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';

class ReportButtonFireWidget extends StatelessWidget {
  const ReportButtonFireWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: buttonColor,
              blurRadius: 130.0,
              spreadRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],

        color: Colors.white
      ),
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(5, 5),
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),

        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department_outlined,
              color: Colors.white,
            ),
            SizedBox(

              height: 10.h,
            ),
            Text("Emergcy call",style: TextStyle(
              color: Colors.white,


            ),)
          ],
        ),
      ),

    );
  }
}
