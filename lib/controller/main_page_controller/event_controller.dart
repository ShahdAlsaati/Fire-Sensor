import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googlemap/model/user_model.dart';
import '../../constants/constants.dart';
import '../../constants/function.dart';
import '../../model/home_model.dart';
import '../../shared/network/local/cache_helper.dart';


class EventController extends GetxController with WidgetsBindingObserver {
  final _apiServer = APIServer();


  var isLoading = false.obs;
  RxBool isBottomWidgetShow = false.obs;

  late UserModel userModel;
  HomeModel homeModel = HomeModel();
  RxList<Feed> feed = <Feed>[].obs;
  RxString cursor = "".obs;
  RxBool lastPage = false.obs;
  bool isGuest = false;

  late ScrollController scrollController;


  setIsGuest(bool isGuestB) {
    isGuest = isGuestB;
  }

  Future<bool> getUserToken() async {
    String? refreshToken = await CacheHelper.getData(key: 'refreshToken');
    String? accessToken = await CacheHelper.getData(key: 'accessToken');
    return refreshToken == null || accessToken == null;
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

  String extractDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String date = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    String time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

fetchDataWithInternetConnection({bool isRef = false}) async {
    print('fetchDataWithInternetConnection called');
    try {

      if (isLoading.value) return;

      isLoading(true);
      if(isRef) {
        updateCursorValue("");
        updateLastPage(false);
        feed.clear();

      }
      if (lastPage.value) return;


      final response = await _apiServer.fetchHomeFeed(cursor.value).onError((error, stackTrace) {
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
        homeModel = HomeModel.fromJson(jsonResponse);
        feed.addAll(homeModel.feed!);

        // Save data to local storage
        await saveFeedData(response.bodyString!);

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
    feed.clear();
    WidgetsBinding.instance.addObserver(this);
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0 && !lastPage.value) {
        if (!isLoading.value) {
          fetchDataWithInternetConnection();
        }
      }
    });

    fetchDataWithInternetConnection(); // Ensure method is called during initialization
  }

  @override
  void onClose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    feed.clear();
    super.onClose();
  }

  reactPost({
    required contentId,
    required contentType,
    required reaction,
  }) async {
    final r = await _apiServer.reactPostComment(
      contentID: contentId,
      contentType: contentType,
      reaction: reaction,
    ).onError((error, stackTrace) {
      Get.snackbar('Error', '$error', backgroundColor: Colors.redAccent);
      return null;
    });

    if (r == null) return;

    if (r.hasError) {
      isLoading.value = false;

      var errorMessage = 'An unknown error occurred';
      if (r.body is Map && r.body.containsKey('codes')) {
        var errors = r.body['codes'];
        print("errors: $errors");

        if (errors is List && errors.contains(103)) {
          errorMessage = 'you have to login';
        }

      }
      errorSnakeBar(errorMessage);
    }

    if (r.statusCode == 200 && r.body['message'] == 'success') {
      // Update the reaction in the local feed or comment
      // _updateReaction(contentId, contentType, reaction);
      callSuccessSnakeBar('Reacted successfully');
    }

  }

  // void _updateReaction(int contentId, String contentType, String reaction) {
  //
  //   final index = feed.indexWhere((feedItem) => feedItem.postId == contentId);
  //
  //   if (index != -1) {
  //     final feedItem = feed[index];
  //     if(feedItem.didReact==true) {
  //       if(feedItem.reaction=='like') {
  //         final updatedFeedItem = feedItem.copyWith(
  //
  //           numberOfReactions: feedItem.numberOfReactions?.copyWith(
  //             like:  (feedItem.numberOfReactions?.like ?? 0) -1,
  //
  //             dislike: reaction == 'dislike'
  //                 ?( (feedItem.numberOfReactions?.dislike ?? 0) + 1)
  //                 : feedItem.numberOfReactions?.dislike,
  //           ),
  //           didReact: reaction=="like"?false:true,
  //           reaction: reaction=="like"?"":"dislike",
  //         );
  //         feed[index] = updatedFeedItem;
  //         feed.refresh();
  //       }
  //       if(feedItem.reaction=='dislike') {
  //         final updatedFeedItem = feedItem.copyWith(
  //           numberOfReactions: feedItem.numberOfReactions?.copyWith(
  //             like: reaction == 'like'
  //                 ? (feedItem.numberOfReactions?.like ?? 0) +1
  //                 : feedItem.numberOfReactions?.like,
  //             dislike: (feedItem.numberOfReactions?.dislike ?? 0) -1
  //           ),
  //           didReact: reaction=="dislike"?false:true,
  //           reaction: reaction=="dislike"?"":"like",
  //         );
  //         feed[index] = updatedFeedItem;
  //         feed.refresh();
  //       }
  //     }
  //     else
  //     {
  //       final updatedFeedItem = feedItem.copyWith(
  //         numberOfReactions: feedItem.numberOfReactions?.copyWith(
  //           like: reaction == 'like'
  //               ? (feedItem.numberOfReactions?.like ?? 0) + 1
  //               : feedItem.numberOfReactions?.like,
  //           dislike: reaction == 'dislike'
  //               ? (feedItem.numberOfReactions?.dislike ?? 0) + 1
  //               : feedItem.numberOfReactions?.dislike,
  //         ),
  //         didReact: true,
  //         reaction: reaction,
  //       );
  //       feed[index] = updatedFeedItem;
  //       feed.refresh();
  //     }
  //
  //
  //   }
  //
  // }


  final storage = GetStorage();
  static const String boxName = 'boxFeed';
  static const String feedListKey = 'feed_list';

  Future<void> getStoredFeedData() async {
    feed.clear();
    final box = GetStorage(boxName);
    final res = box.read(feedListKey);
    if (res != null) {
      var jsonResponse = json.decode(res);
      homeModel = HomeModel.fromJson(jsonResponse);
      feed.assignAll(homeModel.feed!);
    }
  }

  Future<void> saveFeedData(String res) async {
    final box = GetStorage(boxName);
    await box.write(feedListKey, res);
  }
}

class APIServer extends GetConnect {
  /// [reactPostComment] -- do react
  Future<Response?> reactPostComment({contentID, contentType, reaction}) async {
    String userId = await CacheHelper.getData(key: 'userId');

    var headers = {
      'Authorization':'Bearer ${CacheHelper.getData(key:'accessToken')}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode(
        {"userId": double.parse(userId),

          "contentType": contentType,
          "reaction": reaction,
          "contentId": contentID

        });

    try {
      // send post request
      final res = await post(
        '${BASE_URL}create/reaction',
        body,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }

  /// [fetchHomeFeed] -- do fetch
  Future<Response?> fetchHomeFeed(String cursor) async {
    var headers = {
      'Authorization': 'Bearer ${CacheHelper.getData(key:'accessToken')}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      String url = '${BASE_URL}read/home?nop=true&ps=5';
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