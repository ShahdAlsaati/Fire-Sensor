import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../model/post_details_model.dart';
import '../../shared/network/local/cache_helper.dart';

class MoreInfoPostController extends GetxController{
  var isExpanded = false.obs;
  var isExpandedForFire = false.obs;
  final _apiServer = APIServer();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
  String extractDateTime(String dateTimeString) {
    // Parse the dateTimeString into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Extract date and time components
    String date = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    String time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    // Return formatted date and time
    return '$date $time';
  }

  late PostModel postDetailsModel;
  RxBool isLoading = true.obs;
  RxList<PostModel> postDetails = <PostModel>[].obs;

  Future<void> getPostAndCommentDetails( postID) async {
    try {
      isLoading(true);
      postDetails.clear();
      final response = await _apiServer.fetchPostDetails( postID).onError((error, stackTrace) {
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

          postDetailsModel = PostModel.fromJson(jsonResponse);
          postDetails.assignAll([postDetailsModel]);



        }
      }
    } catch (e) {
      print('laaaaaaaaaaaaa');
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }





}
class APIServer extends GetConnect {

  /// [fetchPostDetails]- do fetch
  Future<Response?> fetchPostDetails(postID) async {

    String token ='Bearer ${CacheHelper.getData(key:'accessToken')??CacheHelper.getData(key:'guestToken')}';
    var headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      // send post request
      final res = await get(

        '${BASE_URL}read/$postID/post',
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }

}
