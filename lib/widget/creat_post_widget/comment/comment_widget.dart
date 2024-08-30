import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/controller/post_controller/comment_controller.dart';

class CommentWidget extends StatelessWidget {
  final CommentController commentController = Get.find();

  final int? userId;
  final int? commentId;
  final String? userName;
  final String? commentBody;
  final String? createdAt;
  final int? likes;
  final int? disLikes;
  final String? reaction;

  CommentWidget({
    super.key,
    required this.userName,
    required this.commentBody,
    required this.createdAt,
    required this.likes,
    required this.disLikes,
    required this.userId,
    required this.commentId,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: textFormFieldColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 1.0.w,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, bottom: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$userName',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '$commentBody',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          commentController.extractDateTime(createdAt.toString()),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                commentController.reactComment(
                                  contentType: "comment",
                                  contentId: commentId!,
                                  reaction: 'like',
                                );
                              },
                              child: reaction == 'like'
                                  ? SvgPicture.string(fillLikeIcon)
                                  : SvgPicture.string(emptyLikeIcon),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "$likes",
                              style: const TextStyle(fontSize: 10),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                commentController.reactComment(
                                  contentType: "comment",
                                  contentId: commentId!,
                                  reaction: 'dislike',
                                );
                              },
                              child: reaction == 'dislike'
                                  ? SvgPicture.string(fillDislikeIcon)
                                  : SvgPicture.string(emptyDislikeIcon),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "$disLikes",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
