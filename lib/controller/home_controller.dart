import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:googlemap/pages/main_page/search_screen.dart';
import 'package:googlemap/pages/map_pages/map_fire_size_screen.dart';
import 'package:googlemap/pages/create_post/create_post_screen.dart';
import 'package:googlemap/pages/porfile_page/profile_screen.dart';
import '../pages/send_report_page/send_report_screen.dart';
import '../pages/main_page/event_screen.dart';

class HomeController extends GetxController {

  RxBool isUser = true.obs;

  updateIsUser(bool user) {
    isUser.value = user;
  }

  HomeController({required bool isUser}) {
    updateIsUser(isUser);
    _initializeScreens();
  }

  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  late Widget currentScreen;
  late List<Widget> screens;
  final List<String> titles = [
    'Nearest Fire',
    'Add Report',
    'Map',
  ];

  void _initializeScreens() {
    currentScreen = EventScreen(isUser: isUser.value);
    screens = [
      EventScreen(isUser: isUser.value),
      MapSizeFireScreen(isUser: isUser.value),
      SendReportScreen(),
      ProfileScreen(isUser: isUser.value),
    ];
  }

  void changeBottom(int index) {
    currentTab = index;
    if (currentTab == 0) {
      currentScreen = EventScreen(isUser: isUser.value);
    } else if (currentTab == 1) {
      currentScreen =  SearchScreen(isUser: isUser.value);
    } else if (currentTab == 2) {
      currentScreen = CreatePostScreen(isUser: isUser.value,);
    } else if (currentTab == 3) {
      currentScreen = MapSizeFireScreen(isUser: isUser.value);
    } else if (currentTab == 4) {
      currentScreen = ProfileScreen(isUser: isUser.value);
    }
    update();
  }
}
