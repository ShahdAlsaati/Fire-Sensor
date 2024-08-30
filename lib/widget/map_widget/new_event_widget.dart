import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';

class NewEventItem extends StatelessWidget {
  const NewEventItem({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: newListColor,
        ),
        child:   Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const  Text(
                'Amelia',
                style: TextStyle(color: Colors.white, fontSize: 16), // Define your TextStyle
              ),
              SizedBox(height: 10.h),
              const   Text(
                'Hotel Guests Evacuated as Fire Erupts in Kitchen ',
                style: TextStyle(color: Colors.white, fontSize: 14), // Define your TextStyle
              ),
            ],
          ),
        ),
      ),
    );
  }
}
