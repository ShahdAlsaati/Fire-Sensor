import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/pages/signin_screens/login_screen.dart';

import '../../constants/constants.dart';
import '../../shared/network/local/cache_helper.dart';

class AuthService extends GetxService {
  Timer? _timer;
  final _apiServer = APIServerS();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startTokenRefresh();
  }

  void _startTokenRefresh() {
    _timer = Timer.periodic(Duration(minutes: 100), (timer) {
      refreshToken();
    });
  }
  Future<void> refreshToken() async {
    try {
      isLoading(true);
      final response = await _apiServer.refreshToken();

      if (response == null) {
        throw Exception("No response received from server.");
      }

      if (response.statusCode == 401) {
        await CacheHelper.removeData(key: 'accessToken');
        await CacheHelper.removeData(key: 'refreshToken');
        await CacheHelper.removeData(key: 'guestToken');
        Get.offAll(() => LoginScreen());
        return;
      }

      if (response.statusCode == 200 && response.body['message'] == 'success') {
        await CacheHelper.removeData(key: 'accessToken');
        await CacheHelper.removeData(key: 'refreshToken');
        await CacheHelper.saveData(key: 'accessToken', value: response.body['newAccessToken']);
        await CacheHelper.saveData(key: 'refreshToken', value: response.body['newRefreshToken']);
      } else {
        Get.snackbar('Error', 'Failed to refresh token: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to refresh token: $e');
      Get.offAll(() => LoginScreen());
    } finally {
      isLoading(false);
    }
  }


  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
class APIServerS extends GetConnect {

  Future<Response?> refreshToken() async {

    var headers = {
      'Authorization':'Bearer ${CacheHelper.getData(key:'refreshToken')}',
      'Content-Type': 'application/json',
    };
    try {
      // send post request
      final res = await post(
          headers: headers,
          '${BASE_URL}refresh-token',
          {}
      );
      print('here look in refreshToken');

      print(res.body);
      return res;
    } catch (e) {

      return await Future.error(e);
    }
  }
  Future<Response?> connect(double latitude, double longitude) async {
    print('connecting');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':'Bearer ${CacheHelper.getData(key:'accessToken')}',
    };
    final body = jsonEncode({
      'coordinates': {
        'longitude': longitude,
        'latitude': latitude,
      }
    });
    try {
      final res = await post(
          headers: headers,
          '${BASE_URL}connect',
          body
      );

      print('here look in connect');
      print(res.body);

      return res;

    } catch (e) {

      return await Future.error(e);
    }
  }

}
