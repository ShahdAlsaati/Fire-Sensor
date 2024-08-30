import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googlemap/controller/post_controller/create_post_controller.dart';
import '../../../constants/theme_and_color/color.dart';
import '../../../constants/constants.dart';


class FeelingsWidget extends StatelessWidget {
  final createPostController = Get.find<CreatePostController>(); // Get the controller outside the Obx widget

  String name;
  String decs1;
  String desc2;
  String op1;
  String op2;
  String op3;

  Map<String,String>mp;

  FeelingsWidget({super.key, required this.name,required this.decs1,required this.desc2,
    required this.op1,required this.op2,required this.op3,required this.mp});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: colorTextInCreatePostAndHintColor,
            fontSize: 15.24.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        divider(),

        SizedBox(
          width: 600.w,
          child: Text(
            decs1,
            style: TextStyle(
              color: colorFeelingsAppear,
              fontSize: 15.24.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
        divider(),
        SingleChildScrollView(
          child: Container(


            width: MediaQuery.of(context).size.width*0.9,

            padding:  EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: textFormFieldColor,

              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),

            ),
            child: Column(

              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  desc2,
                  style:  TextStyle(
                    color: colorFeelingDis,
                    fontSize: 15.24.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                roundedButton(value: 0,
                  title: op1,
                ),
                roundedButton(
                  value: 1,
                  title: op2,
                ),
                roundedButton(
                  value: 2,
                  title: op3,
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget roundedButton({required value, required title}){

    return Obx(() {
            return RadioListTile<int>(
            activeColor:buttonColor,
        value: value,
        groupValue:createPostController.selectedButtonIndex.value,
        onChanged: (int? newValue) {
          createPostController.setSelectedButtonIndex(newValue!);
          createPostController.updateFeelingsId(mp[title]!);

        },
        title: Text(
          title,
          style:  TextStyle(
            color: colorFeelingDis,
            fontSize: 15.24.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),

        ),

      );
          },
    );  }

}