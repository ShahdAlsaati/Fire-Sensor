import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/controller/home_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/icon/icons_svg.dart';

class HomePage extends StatelessWidget {
  bool isUser;

  HomePage({super.key, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(isUser: isUser),
      builder: (ctr) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: GetBuilder<HomeController>(
            init: HomeController(isUser: isUser),
            builder: (ctr) {
              return PageStorage(
                bucket: ctr.bucket,
                child: ctr.currentScreen,
              );
            },
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            shape: const CircularNotchedRectangle(),
            notchMargin: 15,
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  navIcon(ctr, 0, 'Feed', feedIcon),
                  navIcon(ctr, 1, 'Search', exploreIcon),
                  navIcon(ctr, 2, 'New', newIcon),
                  navIcon(ctr, 3, 'Map', mapIcon),
                  navIcon(ctr, 4, 'Profile', personIcon),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  navIcon(controller, index, name, iconName) {
    return MaterialButton(
      minWidth: 60.w,
      onPressed: () {
        controller.changeBottom(index);
      },
      child: Column(
        children: [
          Center(
            child: SvgPicture.string(
              iconName,
              color: controller.currentTab == index ? buttonColor : textColor,
            ),
          ),
           SizedBox(
            height: 4.h,
          ),
          Center(
            child: Text(
              name,
              style: TextStyle(
                color: controller.currentTab == index ? buttonColor : textColor,
                fontSize: 10.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
