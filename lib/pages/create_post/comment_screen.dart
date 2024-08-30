import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/controller/main_page_controller/event_controller.dart';
import 'package:googlemap/widget/creat_post_widget/comment/add_comment_text.dart';
import 'package:googlemap/widget/creat_post_widget/comment/comment_widget.dart';
import 'package:googlemap/widget/local/loading_circle_widget.dart';

import '../../controller/post_controller/comment_controller.dart';
import '../../model/post_details_model.dart';

class CommentScreen extends StatelessWidget {
  final int? postID;
  bool isUser;

  CommentScreen({super.key, required this.postID, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final CommentController commentController = Get.put(CommentController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: const Text(
          'Comments',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<CommentController>(
          // init: CommentController(),
          builder: (controller) {
            return FutureBuilder(
              future: commentController.fetchComment(postID!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 154,
                        ),
                        CircularProgressIndicator(
                          color: buttonColor,
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text('Loading ....'),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: Obx(() {
                          if (commentController.isLoadingForAddComment.value) {
                            return LoadingWidget();
                          }
                          if (commentController.comments.isNotEmpty &&
                              commentController.isLoadingForAddComment.value == false) {
                            return ListView.builder(
                              shrinkWrap: false,
                              itemCount: commentController.comments.length + 1,
                              itemBuilder: (context, index) {
                                if (index == commentController.comments.length) {
                                  return Obx(() {
                                    if (commentController.lastPage.value == false) {
                                      return TextButton(
                                        onPressed: () {
                                          commentController.fetchComment(postID!);
                                        },
                                        child: const Text(
                                          'Read more comments',
                                          style: TextStyle(color: buttonColor),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  });
                                } else {
                                  Comments comments = commentController.comments[index];
                                  return CommentWidget(
                                    reaction: comments.reaction,
                                    commentBody: comments.commentBody,
                                    createdAt: comments.createdAt,
                                    userId: int.parse(comments.userId!.toString()),
                                    userName: comments.username,
                                    commentId: int.parse(comments.commentId!.toString()),
                                    likes: comments.numberOfReactions!.like ?? 0,
                                    disLikes: comments.numberOfReactions!.dislike ?? 0,
                                  );
                                }
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('no comments'),
                            );
                          }
                        }),
                      ),
                      isUser ? AddCommentText(postId: postID!) : Container(),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
