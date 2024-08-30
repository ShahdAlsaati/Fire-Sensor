// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/constants/feelings.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import 'package:googlemap/controller/post_controller/more_info_post_controller.dart';
import 'package:googlemap/pages/create_post/comment_screen.dart';

class MoreFireInfoScreen extends GetView<MoreInfoPostController> {
  int postID;
  bool isUser;
  MoreFireInfoScreen({super.key, required this.postID, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final MoreInfoPostController moreInfoPostController =
        Get.put(MoreInfoPostController());

    print(postID);
    print('Comment Screen');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body: FutureBuilder(
        future: moreInfoPostController.getPostAndCommentDetails(postID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 360,
                  ),
                  CircularProgressIndicator(
                    color: buttonColor,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text('Loading ....')
                ],
              ),
            );
          } else {
            return Obx(
              () {
                var postDetails = moreInfoPostController.postDetails[0];
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1,
                      colors: [
                        Colors.transparent, // Start with transparent color
                        Colors.red, // Primary red color
                        Colors.redAccent, // Red accent color
                        Colors.black
                            .withOpacity(0.2), // Transparent black color
                      ],
                      stops: const [
                        0.0,
                        0.2,
                        0.5,
                        1.0
                      ], // Adjust the gradient stops
                    ),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.66,
                          decoration: const BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: ListView(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              divider(),
                              divider(),
                              divider(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  'Post',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              Center(
                                child: Obx(
                                  () => ExpansionTile(
                                    iconColor: buttonColor,
                                    initiallyExpanded: false,
                                    onExpansionChanged: (bool expanded) {
                                      moreInfoPostController.isExpanded.value =
                                          expanded;
                                    },
                                    title: Text(
                                      postDetails.postBody.toString(),
                                      maxLines: moreInfoPostController
                                              .isExpanded.value
                                          ? 10
                                          : 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              divider(),
                               Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  'Fire Size',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Center(
                                child: Obx(
                                  () => ExpansionTile(
                                    iconColor: buttonColor,
                                    initiallyExpanded: false,
                                    onExpansionChanged: (bool expanded) {
                                      moreInfoPostController
                                          .isExpandedForFire.value = expanded;
                                    },
                                    title: Text(
                                      (postDetails.feelingId.toString() == "1")
                                          ?   lv1_descrption_2
                                          : (postDetails.feelingId.toString() == "2" )
                                              ? lv2_descrption_2
                                              : lv3_descrption_2,
                                      maxLines: moreInfoPostController
                                              .isExpandedForFire.value
                                          ? 10
                                          : 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              divider(),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: textFormFieldColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.string(locationIcon,
                                                    color: postBodyTextColor),
                                                 SizedBox(
                                                  width: 8.w,
                                                ),
                                                const Text(
                                                  'Location',
                                                  style: TextStyle(
                                                      color: postBodyTextColor),
                                                ),
                                              ],
                                            ),
                                            const Text(
                                             '',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.string(
                                                  fireSize,
                                                ),
                                                 SizedBox(
                                                  width: 8.w,
                                                ),
                                                const Text(
                                                  'Fire Size',
                                                  style: TextStyle(
                                                      color: postBodyTextColor),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              (postDetails.feelingId
                                                              .toString() ==
                                                          "1" ||
                                                      postDetails.feelingId
                                                              .toString() ==
                                                          "4" ||
                                                      postDetails.feelingId
                                                              .toString() ==
                                                          "7")
                                                  ? lv1_name
                                                  : (postDetails.feelingId
                                                                  .toString() ==
                                                              "2" ||
                                                          postDetails.feelingId
                                                                  .toString() ==
                                                              "5" ||
                                                          postDetails.feelingId
                                                                  .toString() ==
                                                              "8")
                                                      ? lv2_name
                                                      : lv3_name,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              divider(),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => CommentScreen(
                                        isUser:isUser,
                                            postID: postID,
                                          ));
                                    },
                                    child: const Text(
                                      'All comments >',
                                      style: TextStyle(color: buttonColor),
                                    ),
                                  ),
                                ],
                              ),
                              divider(),
                              SizedBox(
                                height: 110.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 120.w, // Specify the desired width here
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: textFormFieldColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              postDetails.comments![index]
                                                  .commentBody!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: textColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: postDetails.comments!.length,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 500.h,
                          left: 100.w,
                          child: Container(
                            width: 200.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                                color: Colors.white10.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  postDetails.username!,
                                  style:  TextStyle(
                                      fontSize: 25.sp, color: backgroundColor),
                                ),
                                divider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.string(
                                      calenderIcon,
                                      color: backgroundColor,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                     Text(
                                     moreInfoPostController.extractDateTime(postDetails.createdAt!) ,
                                      style: const TextStyle(color: backgroundColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
