import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/constants.dart';
import '../../model/post_details_model.dart';
import '../../shared/network/local/cache_helper.dart';

class CommentController extends GetxController {
  final _apiServer = APIServer();

  RxList<Comments> comments = <Comments>[].obs;
  RxList<PostModel> postDetails = <PostModel>[].obs;
  late PostModel commentModel;
  RxBool isLoadingForAddComment = false.obs;
  final formKeyForComments = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  RxBool isLoading = true.obs;
  RxString cursor = "".obs;
  RxBool lastPage = false.obs;

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

  Future<void> fetchComment(int postID, {bool reset = false}) async {
    try {
      isLoading(true);

      if (reset) {
        comments.clear();
        cursor.value ="";
        lastPage.value = false;
      }

      if (lastPage.value) return;

      final response = await _apiServer.fetchComment(postID, cursor.value).onError((error, stackTrace) {
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
        var jsonResponse = json.decode(response.bodyString!);
        commentModel = PostModel.fromJson(jsonResponse);

        if (jsonResponse['lastPage'] == true) {
          updateLastPage(true);
        } else {
          // Update the cursor only if it's pointing to a new set of comments
          updateCursorValue(jsonResponse['cursor']);
        }

        // Only add new comments to the list
        comments.addAll(commentModel.comments!.where((newComment) =>
        !comments.any((existingComment) => existingComment.commentId == newComment.commentId)));
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addComment({required postId}) async {
    try {
      if (formKeyForComments.currentState?.validate() == false) return;

      if (isLoadingForAddComment.isTrue) return;

      isLoadingForAddComment.value = true;

      final r = await _apiServer.addComment(
        postId: postId,
        commentBody: commentController.text,
      ).onError((error, stackTrace) {
        Get.snackbar(
          'Error',
          '$error',
          backgroundColor: Colors.redAccent,
        );
        isLoading.value = false;
        return null;
      });

      if (r == null) {
        return;
      }

      if (r.hasError) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          '${r.body}',
          backgroundColor: Colors.redAccent,
        );
      }

      if (r.statusCode == 200) {
        if (r.body['message'] == 'success') {
          commentController.clear();
          await fetchComment(postId, reset: true); // Fetch comments after adding a new one
          Get.snackbar(
            'Success',
            'Comment added successfully',
            backgroundColor: postConstTextColor,
          );
          isLoading.value = false;
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoadingForAddComment(false);
    }
  }

  reactComment({
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
      Get.snackbar('Error', '${r.body}', backgroundColor: Colors.redAccent);
      return;
    }

    if (r.statusCode == 200 && r.body['message'] == 'success') {
      _updateReaction(contentId, contentType, reaction);


      Get.snackbar('Success', 'Reacted successfully', backgroundColor: Colors.white10);
    }
  }
  void _updateReaction(int contentId, String contentType, String reaction) {

    final index = comments.indexWhere((feedItem) => feedItem.commentId == contentId);
    if (index != -1) {
      final feedItem = comments[index];
      if(feedItem.didReact==true) {
        if(feedItem.reaction=='like') {
          final updatedFeedItem = feedItem.copyWith(
            numberOfReactions: feedItem.numberOfReactions?.copyWith(
              like: (feedItem.numberOfReactions?.like ?? 0) -1,
              dislike: reaction == 'dislike'
                  ? (feedItem.numberOfReactions?.dislike ?? 0) + 1
                  : feedItem.numberOfReactions?.dislike,
            ),
            didReact: reaction=="like"?false:true,
            reaction: reaction=="like"?"":"dislike",
          );
          comments[index] = updatedFeedItem;
          comments.refresh();
        }
        if(feedItem.reaction=='dislike') {
          final updatedFeedItem = feedItem.copyWith(
            numberOfReactions: feedItem.numberOfReactions?.copyWith(
              like: reaction == 'like'
                  ? (feedItem.numberOfReactions?.like ?? 0) +1
                  : feedItem.numberOfReactions?.like,
              dislike: (feedItem.numberOfReactions?.dislike ?? 0) -1,
            ),
            didReact: reaction=="dislike"?false:true,
            reaction: reaction=="dislike"?"":"like",
          );
          comments[index] = updatedFeedItem;
          comments.refresh();
        }
      }
      else
      {
        final updatedFeedItem = feedItem.copyWith(
          numberOfReactions: feedItem.numberOfReactions?.copyWith(
            like: reaction == 'like'
                ? (feedItem.numberOfReactions?.like ?? 0) + 1
                : feedItem.numberOfReactions?.like,
            dislike: reaction == 'dislike'
                ? (feedItem.numberOfReactions?.dislike ?? 0) + 1
                : feedItem.numberOfReactions?.dislike,
          ),
          didReact: true,
          reaction: reaction,
        );
        comments[index] = updatedFeedItem;
        comments.refresh();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}

class APIServer extends GetConnect {
  Future<Response?> addComment({required postId, required String commentBody}) async {
    var headers = {
      'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "commentBody": commentBody,
      "postId": postId,
    });

    try {
      final res = await post(
        '${BASE_URL}create/comment',
        body,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }

  Future<Response?> fetchComment(int postID, String cursor) async {
    String token = 'Bearer ${CacheHelper.getData(key: 'accessToken') ?? CacheHelper.getData(key: 'guestToken')}';

    var headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      String url = '${BASE_URL}read/$postID/post?nop=true&ps=6';
      if (cursor.isNotEmpty) {
        url += '&cursor=$cursor';  // Ensure correct format for cursor
      }

      final res = await get(
        url,
        headers: headers,
      );

      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }

  Future<Response?> reactPostComment({contentID, contentType, reaction}) async {
    String userId = await CacheHelper.getData(key: 'userId');

    var headers = {
      'Authorization': 'Bearer ${CacheHelper.getData(key:'accessToken')}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "userId": double.parse(userId),
      "contentType": contentType,
      "reaction": reaction,
      "contentId": contentID,
    });

    try {
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
}

