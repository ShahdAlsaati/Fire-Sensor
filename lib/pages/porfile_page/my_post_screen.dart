import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import 'package:googlemap/controller/profile_controller/profile_controller.dart';
import 'package:googlemap/widget/local/loading_circle_widget.dart';
import '../../constants/theme_and_color/color.dart';
import '../../constants/constants.dart';
import '../../model/home_model.dart';
import '../../widget/main_page_widget/fire_post_widget.dart';
import '../main_page/more_fire_info_screen.dart';

class MyPostScreen extends StatelessWidget {
  final bool isUser;

  MyPostScreen({super.key, required this.isUser});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GetBuilder<ProfileController>(
              init: ProfileController(),
              builder: (controller) {
                return FutureBuilder(
                  future: profileController.fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingWidget();
                    } else {
                      if (profileController.userModel.posts != null) {
                        var user = profileController.userModel;
                        return Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 47.w,
                                height: 47.h,
                                padding: EdgeInsets.only(
                                  top: 8.h,
                                  left: 10.w,
                                  right: 11.w,
                                  bottom: 13.h,
                                ),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFF5834),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11.19),
                                  ),
                                ),
                                child: SvgPicture.string(
                                  personIcon,
                                  color: textColor,
                                ),
                              ),
                              divider(),
                              Text(user.username.toString()),
                              divider(),
                              Text(user.email.toString()),
                              divider(),
                              divider(),
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: textFormFieldColor,
                              ),
                              Expanded(
                                child: (user.posts!.isNotEmpty)
                                    ? Obx(() {
                                  if (profileController.feed.isNotEmpty) {
                                    return RefreshIndicator(
                                      color: buttonColor,
                                      onRefresh: () async {
                                        await profileController
                                            .fetchUserProfile(
                                            isRef:
                                            true); // Fetch events again
                                      },
                                      child: ListView.builder(
                                        controller: profileController
                                            .scrollController,
                                        itemCount:
                                        profileController.feed.length +
                                            1,
                                        itemBuilder: (context, index) {
                                          if (index ==
                                              profileController
                                                  .feed.length) {
                                            if (profileController
                                                .isLoading.value) {
                                              return Center(
                                                child:
                                                CircularProgressIndicator(
                                                  color: buttonColor,
                                                ),
                                              );
                                            } else {
                                              return SizedBox(); // No more items to load
                                            }
                                          }

                                          Feed feed = profileController
                                              .feed[index];
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
                                              comments:
                                              feed.numberOfComments ??
                                                  0,
                                              likes: feed
                                                  .numberOfReactions
                                                  ?.like ??
                                                  0,
                                              disLikes: feed
                                                  .numberOfReactions
                                                  ?.dislike ??
                                                  0,
                                              userId: feed.userId!,
                                              postID: feed.postId!,
                                              isMyPost: false,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(child: Text('No posts'));
                                  }
                                })
                                    : Center(
                                  child: Text('No Post here'),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: Text('Something happened'));
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
