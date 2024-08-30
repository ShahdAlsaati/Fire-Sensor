import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/controller/main_page_controller/event_controller.dart';
import 'package:googlemap/model/home_model.dart';
import 'package:googlemap/pages/main_page/search_screen.dart';
import 'package:googlemap/pages/send_report_page/send_report_screen.dart';
import 'package:googlemap/widget/guest/guest_widget.dart';
import 'package:googlemap/widget/main_page_widget/fire_post_widget.dart';
import '../../constants/theme_and_color/color.dart';
import '../../constants/icon/icons_svg.dart';
import '../../widget/local/loading_circle_widget.dart';
import '../../widget/main_page_widget/search_widget.dart';
import 'more_fire_info_screen.dart';

class EventScreen extends StatelessWidget {
  final bool isUser;

  EventScreen({super.key, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.put(EventController());

    return Scaffold(

      backgroundColor: backgroundColor,
      body: isUser
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            SearchWidget(
              onFieldSubmitted: (value) {
              },
            ),
            const SizedBox(height: 7),
            Obx(() {
              if (eventController.isGuest) {
                return const GuestWidget();
              } else if (eventController.isLoading.value &&
                  eventController.feed.isEmpty) {
                return const Center(child: LoadingWidget());
              } else {
                return Expanded(
                  child: RefreshIndicator(
                    color: buttonColor,
                    onRefresh: () async {
                      await eventController.fetchDataWithInternetConnection(isRef: true);
                    },
                    child: Obx(() {
                      return ListView.builder(
                        controller: eventController.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: eventController.feed.length + 1, // Add 1 for the loader
                        itemBuilder: (context, index) {
                          if (index == eventController.feed.length) {
                            // Return the CircularProgressIndicator for the last item
                            return eventController.isLoading.value
                                ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: buttonColor,),
                              ),
                            )
                                : SizedBox.shrink(); // Return an empty box if not loading
                          }
                          Feed feed = eventController.feed[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => MoreFireInfoScreen(
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
                      );
                    }),
                  ),
                );
              }
            }),
          ],
        ),
      )
          : const GuestWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () {
          Get.to(() => SendReportScreen());
        },
        child: SvgPicture.string(callEmIcon),
      ),
    );
  }
}
