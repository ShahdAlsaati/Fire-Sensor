import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonNavigationWidget extends StatelessWidget {

  Color color;
  Function function;
  String iconName;
  String name;

  ButtonNavigationWidget({super.key, required this.function,required this.iconName,required this.color,required this.name});
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        MaterialButton(
          onPressed: function(),
          child: Center(
            child: SvgPicture.string(
              iconName,
              color: color,
            ),
          ),
        ),
        // Text(name),
      ],
    );
  }
}
