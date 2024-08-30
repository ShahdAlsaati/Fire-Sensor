import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/theme_and_color/color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(
            height: 154.h,
          ),
          const CircularProgressIndicator(
            color: buttonColor,
          ),
          SizedBox(
            height: 7.h,
          ),
          const Text('Loading ....')
        ],
      ),
    );
  }
}
