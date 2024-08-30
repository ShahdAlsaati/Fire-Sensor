
import 'package:flutter/material.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';


class LoadingLinearWidget extends StatelessWidget {
  const LoadingLinearWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LinearProgressIndicator(color: buttonColor),
        Text('is loading ...'),
      ],
    );
  }
}
