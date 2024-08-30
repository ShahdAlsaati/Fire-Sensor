import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import '../../../constants/theme_and_color/color.dart';
import '../../../controller/post_controller/comment_controller.dart';

class AddCommentText extends StatelessWidget {
  CommentController commentController=Get.find();

  int postId;
  AddCommentText({super.key,required this.postId});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: commentController.formKeyForComments,
      child: Container(
        height: 100.h,
        width: double.infinity,
        color: Colors.black,
        child: Padding(
          padding:  EdgeInsets.only(left: 8.0.w,right: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: textFormFieldColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 70.h,
                width: 250.w,
                child: Padding(
                  padding:  EdgeInsets.only(left: 18.0.w, top: 10.h),
                  child: TextFormField(
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: commentController.commentController,
                    validator: (value){
                      if(value!.isEmpty) {
                        return 'You cannot send nothings';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: colorTextInCreatePostAndHintColor,
                      fontSize: 13.50.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Add a Comment ...',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textFormFieldColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textFormFieldColor)),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() {
                return Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: ()async {
                    await  commentController.addComment(postId: postId);
                    commentController.commentController.text="";
                    // eventController.update();
                    commentController.update();
                    },
                    icon:commentController.isLoadingForAddComment.value==true?const CircularProgressIndicator(color: backgroundColor,):
                    SvgPicture.string(

                      sendCommentIcon,

                    ),
                  ),
                );
              },
              )
            ],
          ),
        ),

      ),
    );

  }
}
