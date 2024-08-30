import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import 'package:googlemap/model/home_model.dart';
import '../../constants/constants.dart';
import '../../model/fire_post_model.dart';
import '../../shared/network/local/cache_helper.dart';


class FirePostController extends GetxController with WidgetsBindingObserver {
  final _apiServer = APIServer();


  var isLoading = false.obs;
  RxBool isBottomWidgetShow = false.obs;

  FirePostModel firePostModel = FirePostModel();
  RxList<Feed> post = <Feed>[].obs;
  RxString cursor = "".obs;
  RxBool lastPage = false.obs;

  late ScrollController scrollController;




  updateBottomWidgetShow(bool b) {
    isBottomWidgetShow.value = b;
  }

  updateLastPage(bool b) {
    lastPage.value = b;
  }

  updateCursorValue(String cursorUpdated) {
    cursor.value = cursorUpdated;
  }

  String extractDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String date = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    String time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  fetchData({bool isRef = false,required int fireId}) async {
    print('fetchDataWithInternetConnection called');
    try {

      if (isLoading.value) return;

      isLoading(true);
      if(isRef) {
        updateCursorValue("");
        updateLastPage(false);
        post.clear();

      }
      if (lastPage.value) return;


      final response = await _apiServer.fetchFirePosts(cursor.value,fireId).onError((error, stackTrace) {
        print('API Error: $error');
        return null;
      });

      if (response == null) {
        print('Response is null');
        return;
      }

      if (response.hasError) {
        print('Response has error: ${response.body}');
        return;
      }

      if (response.statusCode == 200) {
        print('Response: ${response.bodyString}');
        var jsonResponse = json.decode(response.bodyString!);
        firePostModel = FirePostModel.fromJson(jsonResponse);
        post.addAll(firePostModel.posts!);
        print("llllllllll");
        print(post);
        // Save data to local storage

        if (jsonResponse['lastPage'] == true) {
          updateLastPage(true);
        } else {
          updateCursorValue(jsonResponse['cursor']);
        }
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    post.clear();
    WidgetsBinding.instance.addObserver(this);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0 && !lastPage.value) {
        if (!isLoading.value) {
          fetchData;
        }
      }
    });
    // Load data from storage if available
    // getStoredFeedData();
    fetchData; // Ensure method is called during initialization
  }

  @override
  void onClose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    post.clear();
    super.onClose();
  }


}

class APIServer extends GetConnect {

  /// [fetchFirePosts] -- do fetch
  Future<Response?> fetchFirePosts(String cursor,int fireId) async {
    String token = 'Bearer ${CacheHelper.getData(key: 'accessToken') ?? CacheHelper.getData(key: 'guestToken')}';

    var headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      String url = '${BASE_URL}read/reports/about/$fireId/fire';
      if (cursor!="") {
        url +='&cursor=$cursor';
      }
      final res = await get(url, headers: headers);
      print('API Response: ${res.body}');
      return res;
    } catch (e) {
      print('API Exception: $e');
      return await Future.error(e);
    }
  }}