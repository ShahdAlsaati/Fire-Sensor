import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap/pages/main_page/more_fire_info_screen.dart';
import '../../constants/theme_and_color/color.dart';
import '../../controller/main_page_controller/search_controller.dart';
import '../../widget/local/laoding_Linear_widget.dart';
import '../../widget/main_page_widget/fire_post_widget.dart';
import '../../widget/main_page_widget/search_widget.dart';

class SearchScreen extends StatelessWidget {
  bool isUser;
   SearchScreen({super.key,required this.isUser});
  @override
  Widget build(BuildContext context) {
    SearchHomeController searchHomeController = Get.put(SearchHomeController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            SearchWidget(
              onFieldSubmitted: (value) {
                searchHomeController.searchDataWithInternetConnection(value);
              },
            ),
            const SizedBox(height: 7),
            Expanded(
              child: Obx(() {
                if (searchHomeController.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: LoadingLinearWidget(),
                  );
                } else if (searchHomeController.feed.isEmpty) {
                  return const Center(child: Text("no post found"));
                } else {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final feed = searchHomeController.feed[index];
                      return InkWell(
                        onTap: (){
                          // if(isUser)
                          Get.to(()=>MoreFireInfoScreen(postID: feed.postId!, isUser: isUser));
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
                    separatorBuilder: (context, index) => const SizedBox(height: 1),
                    itemCount: searchHomeController.feed.length,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
// Padding(
//   padding: const EdgeInsets.only(left: 18.0,right: 18),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       InkWell(
//           onTap: (){},
//           child: SortFireButton(text: 'nearby',icon: calenderIcon )),
//       const SizedBox(
//         width: 4,
//       ),
//       InkWell(
//           onTap: (){},
//           child: SortFireButton(text: 'location', icon: locationIcon,)),
//       const SizedBox(
//         width: 4,
//       ),
//       InkWell(
//           onTap: (){},
//           child: SortFireButton(text: 'time', icon: hourIcon)),
//       const SizedBox(
//         height: 8,
//       ),
//     ],
//   ),
// ),