import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/model/home_model.dart';
import 'package:googlemap/pages/main_page/more_fire_info_screen.dart';
import '../../constants/theme_and_color/color.dart';
import '../../controller/map_controller/fire_post_controller.dart';
import '../../widget/local/loading_circle_widget.dart';
import '../../widget/main_page_widget/fire_post_widget.dart';

class FirePostScreen extends StatelessWidget {
  final int fireId;
  final bool isUser;

  FirePostScreen({super.key, required this.fireId, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final FirePostController firePostController = Get.put(FirePostController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Fire Post'),
      ),
      body: GetBuilder<FirePostController>(
        builder: (context) {
          return FutureBuilder(
            future: firePostController.fetchData(isRef: true, fireId: fireId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        if (firePostController.isLoading.value &&
                            firePostController.post.isEmpty) {
                          return const Center(child: LoadingWidget());
                        } else {
                          return Expanded(
                            child: RefreshIndicator(
                              color: buttonColor,
                              onRefresh: () async {
                                await firePostController.fetchData(
                                    isRef: true, fireId: fireId);
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight,
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            controller: firePostController.scrollController,
                                            itemCount: firePostController.post.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index == firePostController.post.length) {
                                                if (firePostController.isLoading.value) {
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      color: buttonColor,
                                                    ),
                                                  );
                                                } else {
                                                  return const SizedBox(); // No more items to load
                                                }
                                              }

                                              Feed feed = firePostController.post[index];
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      MoreFireInfoScreen(
                                                        isUser: isUser,
                                                        postID: feed.postId!,
                                                      ));
                                                },
                                                child: FirePostWidget(
                                                  didReact: feed.didReact,
                                                  isUser: isUser,
                                                  reaction: feed.reaction,
                                                  userName: feed.username,
                                                  postBody: feed.postBody,
                                                  createdAt: feed.createdAt,
                                                  comments: feed.numberOfComments ?? 0,
                                                  likes: feed.numberOfReactions?.like ?? 0,
                                                  disLikes: feed.numberOfReactions?.dislike ?? 0,
                                                  userId: feed.userId!,
                                                  postID: feed.postId!,
                                                  isMyPost: false,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
