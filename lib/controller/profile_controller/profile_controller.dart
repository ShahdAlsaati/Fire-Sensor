import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/function.dart';
import 'package:googlemap/model/user_model.dart';
import '../../constants/constants.dart';
import '../../model/home_model.dart';
import '../../shared/network/local/cache_helper.dart';

class ProfileController extends GetxController with WidgetsBindingObserver {

  final _apiServer = APIServer();
  RxList<Feed> feed = <Feed>[].obs;
  RxString cursor = "".obs;
  RxBool lastPage = false.obs;
  late ScrollController scrollController;
  RxBool isBottomWidgetShow = false.obs;


  Future<List<String>> getUserDetails() async {
    String? id = await CacheHelper.getData(key: 'id');
    String? name = await CacheHelper.getData(key: 'username');
    String? email = await CacheHelper.getData(key: 'email');
    String? refreshToken=await CacheHelper.getData(key: 'refreshToken');
    String? accessToken=await CacheHelper.getData(key: 'accessToken');
    bool? emailVerified=await CacheHelper.getData(key: 'emailVerified');

    if(email==null||emailVerified==null){
      fetchUserEmailName();
      }

    return [id ?? '', name ?? '', email ?? '',refreshToken??'',accessToken??''];
  }
  RxBool isLoading = true.obs;
  List<String?> user = [];

  @override
  void onInit() {
    super.onInit();
    feed.clear();
    WidgetsBinding.instance.addObserver(this);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0 && !lastPage.value) {
        if (!isLoading.value) {
          fetchUserProfile();
        }
      }
    });
    fetchUserEmailName();
    fetchUserProfile(); // Ensure method is called during initialization
  }

  @override
  void onClose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    feed.clear();
    super.onClose();
  }
  updateBottomWidgetShow(bool b) {
    isBottomWidgetShow.value = b;
  }

  updateLastPage(bool b) {
    lastPage.value = b;
  }

  updateCursorValue(String cursorUpdated) {
    cursor.value = cursorUpdated;
  }
  fetchUserEmailName() async {
    try{
      if (isLoading.value) return;

      isLoading(true);

      user.clear();

      final response =
      await _apiServer.fetchUserPostAndDetails(cursor.value,extra: false).onError((error, stackTrace) {
        Get.snackbar(
          'Error',
          '$error',
          backgroundColor: Colors.redAccent,
        );
        return null;
      });

      if (response == null) {
        return;
      }

      if (response.hasError) {
        var errorMessage = 'An unknown error occurred';
        if (response.body is Map && response.body.containsKey('codes')) {
          var errors = response.body['codes'];
          print("errors: $errors");

          if (errors is List && errors.contains(103)) {
            errorMessage = 'you have to login';
          }
          else{
            errorSnakeBar(errorMessage);
          }
        }

      }
      if (response.statusCode == 200) {
        print('await r.body');
        print(await response.body);
        if (response.body['message'] == 'success') {
          await CacheHelper.saveData(key: 'email', value: response.body['email'].toString());
          await CacheHelper.saveData(key: 'emailVerified', value: response.body['emailVerified']);

          print(response.body);

          var jsonResponse = json.decode(response.bodyString!);
          print('i  am in userModel');
          print(jsonResponse);

          userModel = UserModel.fromJson(jsonResponse);
          feed.addAll(userModel.posts!);
          print("userModel :");

          print(userModel.email);
          if (jsonResponse['lastPage'] == true) {
            updateLastPage(true);
          } else {
            updateCursorValue(jsonResponse['cursor']);
          }
        }
      }

    }
    catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }

  UserModel userModel=UserModel();
   fetchUserProfile({bool isRef = false}) async {
    try{
      if (isLoading.value) return;

      isLoading(true);
      if(isRef) {
        updateCursorValue("");
        updateLastPage(false);
        feed.clear();

      }
      if (lastPage.value) return;

      user.clear();

      final response =
      await _apiServer.fetchUserPostAndDetails(cursor.value).onError((error, stackTrace) {
        Get.snackbar(
          'Error',
          '$error',
          backgroundColor: Colors.redAccent,
        );
        return null;
      });

      if (response == null) {
        return;
      }

      if (response.hasError) {
        Get.snackbar(
          'Error',
          '${response.body}',
          backgroundColor: Colors.redAccent,
        );
      }
      if (response.statusCode == 200) {
        print('await r.body');
        print(await response.body);
        if (response.body['message'] == 'success') {
          print('jsonResponse');

          var jsonResponse = json.decode(response.bodyString!);
          print('i  am in userModel');
          print(jsonResponse);

          userModel = UserModel.fromJson(jsonResponse);
          feed.addAll(userModel.posts!);
          print("userModel :");

          print(userModel.email);
          if (jsonResponse['lastPage'] == true) {
            updateLastPage(true);
          } else {
            updateCursorValue(jsonResponse['cursor']);
          }
        }
      }

      }
     catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }

}
class APIServer extends GetConnect {

  /// [fetchUserPostAndDetails] -- do fetch
  Future<Response?> fetchUserPostAndDetails(String cursor, {bool extra = true}) async {
    String userId = await CacheHelper.getData(key: 'userId');

    var headers = {
      'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      String url = '${BASE_URL}read/$userId/profile?extra=$extra&ps=7&pn=1';
      if (cursor!="") {
        url +='&cursor=$cursor';
      }      final res = await get(
        url,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }


}
