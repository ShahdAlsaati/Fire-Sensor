import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googlemap/controller/post_controller/create_post_controller.dart';
import 'package:googlemap/controller/signin_controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:googlemap/controller/signin_controller/register_controller.dart';
import 'package:googlemap/controller/signin_controller/reset_password_controller.dart';
import 'package:googlemap/pages/layout/home_page.dart';
import 'package:googlemap/pages/signin_screens/login_screen.dart';
import 'package:googlemap/services/remote/auth_service.dart';
import 'package:googlemap/shared/network/local/cache_helper.dart';
import 'constants/String/error.dart';
import 'constants/constants.dart';
import 'constants/function.dart';
import 'controller/main_page_controller/verify_email_controller.dart';
import 'controller/map_controller/map_controller.dart';
import 'controller/signin_controller/foreget_password_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthService());
  Get.put(APIServerS());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Initialize MapController and get current location
  final mapController = Get.put(MapController());
  await mapController.getCurrentLocation();  // Ensure location is fetched

  await CacheHelper.init();

  Widget widget;
  String? userId = await CacheHelper.getData(key: 'userId');
  String? guestToken = await CacheHelper.getData(key: 'guestToken');
  String? refreshToken = await CacheHelper.getData(key: 'refreshToken');
  String? accessToken = await CacheHelper.getData(key: 'accessToken');

  print('BASE_URL: $BASE_URL');
  print("here is id: $userId");
  print("here is refreshToken: $refreshToken");
  print("here is accessToken: $accessToken");

  if (refreshToken != null || accessToken != null) {
    widget = HomePage(isUser: true);
  } else if (guestToken != null) {
    widget = HomePage(isUser: false);
  } else {
    widget = const LoginScreen();
  }

  runApp(MyApp(startWidget: widget));
}



class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<APIServerS>();
    final mapController = Get.find<MapController>();

    // Ensure map position is available
    if (mapController.position != null) {
      if (mapController.position!.latitude != null) {
        apiService.connect(mapController.position!.latitude, mapController.position!.longitude);
      } else {
        errorSnakeBar(locationOff);
      }
    } else {
      // Handle the case where position is not yet available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mapController.position == null) {
          errorSnakeBar(locationOff);
        }
      });
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData.dark(),
        initialBinding: BindingsBuilder(
              () {
            Get.lazyPut(() => LoginController(), fenix: true);
            Get.lazyPut(() => RegisterController(), fenix: true);
            Get.lazyPut(() => CreatePostController());
            Get.lazyPut(() => ForgetPasswordController(), fenix: true);
            Get.lazyPut(() => ResetPasswordController(), fenix: true);
            Get.lazyPut(() => VerifyEmailController(), fenix: true);
          },
        ),
        home: startWidget,
      ),
    );
  }
}
