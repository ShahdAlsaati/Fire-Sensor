import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import 'package:googlemap/controller/post_controller/create_post_controller.dart';
import 'package:googlemap/pages/map_pages/map_screen.dart';


class SetLocationWidget extends StatelessWidget {
 CreatePostController controller=Get.find();

  SetLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder:(context, orientation)  {
        double contentVerticalPadding = orientation == Orientation.portrait ? 16.h : 12.h;
        double contentHorizontalPadding = orientation == Orientation.portrait ? 8.w : 6.w;
        return Container(
          height: 70.h,
          width: 500.w,
          decoration: BoxDecoration(
            color: textFormFieldColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 1.0.w,
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 8.0.w, horizontal: 18.h),
            child: InkWell(
              onTap: () {
                Get.to(()=>MapScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(
                          () {
                            return Text(
                        (controller.longitudeof!=null &&controller.latitudeof!=null
                            &&controller.longitudeof.toString().length>5
                            &&controller.latitudeof.toString().length>5)?
                        '${controller.longitudeof!.value.toString().substring(0,4)},'
                            '${controller.latitudeof!.value.toString().substring(0,4)}'
                            :'please set fire location',
                         style:  TextStyle(
                              color:colorFeelingDis ,
                              fontSize: 15.24.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),

                          );
                          },
                    ),
                  ),
                  SvgPicture.string(selectLocationIcon),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
