import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/constants/icon/icons_svg.dart';
import 'package:googlemap/pages/create_post/comment_screen.dart';

import '../../controller/main_page_controller/event_controller.dart';

class FirePostWidget extends StatefulWidget {
  int  userId;
  int  postID;
  String? userName;
  String? postBody;
  String? createdAt;
  int? comments;
  int likes=0;
  int disLikes=0;
  bool isMyPost=false;
  String? reaction;
  bool isUser;
  bool? didReact;


  FirePostWidget({super.key,required this.userName,required this.postBody,
    required this.createdAt,required this.comments,required this.likes,
    required this.disLikes,required this.userId,required this.postID,required this.isMyPost,
   this.reaction,required this.isUser,required this.didReact});

  @override
  State<FirePostWidget> createState() => _FirePostWidgetState();
}


class _FirePostWidgetState extends State<FirePostWidget> {

  int likes=0;
  int disLikes=0;
  String? reaction;
  bool? didReact;

  @override
  void initState() {

    likes=widget.likes;
    if(widget.likes!=null) {
      disLikes = widget.disLikes;
    }
    else{
      disLikes=0;}

    if(widget.likes!=null) {
      disLikes = widget.disLikes;
    }
    else{
      disLikes=0;}

    reaction=widget.reaction;
    didReact=widget.didReact;

    super.initState();
  }
  void _updateReaction(String reactionTapUser,bool isUser) {


      setState(() {
        if(isUser==true) {
          if (didReact == true) {
            if (reactionTapUser == 'like') {
              if (reaction == 'like') {
                if (likes == 0) {
                  likes = 0;
                }
                else {
                  likes -= 1;
                }
                didReact = false;
                reaction = null;
              }
              else if (reaction == 'dislike') {
                likes += 1;
                if (disLikes == 0) {
                  disLikes = 0;
                }
                else {
                  disLikes -= 1;
                }
                didReact = true;
                reaction = 'like';
              }
            }
            if (reactionTapUser == 'dislike') {
              if (reaction == 'dislike') {
                disLikes -= 1;
                didReact = false;
                reaction = null;
              }
              else if (reaction == 'like') {
                likes -= 1;
                disLikes += 1;
                didReact = true;
                reaction = 'dislike';
              }
            }
          }
          else {
            if (reactionTapUser == 'like') {
              reaction = 'like';
              likes += 1;
            }
            else {
              reaction = 'dislike';
              disLikes += 1;
            }
            didReact = true;
          }
        }
      });




  }
  EventController controller=Get.find();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.only(left: 8.0.w,right: 8.0.w,top: 2.h,bottom: 2.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: textFormFieldColor,

        ),


        child: Padding(
          padding:  EdgeInsets.only(left: 10.0.w,top: 10.h,right: 8.w,bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.userName}",style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.16.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  )),
                  divider(),
                  widget.isMyPost?PopupMenuButton(
                      icon: const Icon(
                        Icons.more_horiz_outlined
                      ),
                      itemBuilder: (value){
                        return <PopupMenuEntry>[
                           PopupMenuItem(
                            value: 'Option 1',
                            child: Row(
                              children: [
                                const Icon(Icons.edit),
                                SizedBox(width: 4.w,),
                                const Text('edit'),
                              ],
                            ), // You can pass any value here
                          ),
                           PopupMenuItem(
                            value: 'Option 2',
                            child: Row(
                              children: [
                                const Icon(Icons.delete,color: Colors.red,),
                                SizedBox(width: 4.w,),

                                const Text('delete',style: TextStyle(
                                  color: Colors.red
                                ),),
                              ],
                            ),
                          ),
                        ];

                  }):PopupMenuButton(
                      icon: const Icon(
                          Icons.more_horiz_outlined
                      ),
                      itemBuilder: (value){
                        return <PopupMenuEntry>[
                           PopupMenuItem(
                            value: 'Option 1',
                            child: Row(
                              children: [
                                const Icon(Icons.report),
                                SizedBox(width: 4.w,),
                                const Text('report'),
                              ],
                            ), // You can pass any value here
                          ),
                        ];

                      }),
                ],
              ),
              Text("${widget.postBody}",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                  color:postBodyTextColor,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,

                ),

              ),
              divider(),

           Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                  controller.extractDateTime(widget.createdAt.toString()),
                    style:  TextStyle(
                      fontSize: 9.sp,

                    ),

                    ),
                    SizedBox(
                        width: 5.w
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            print(widget.postID);
                            controller.reactPost(
                              contentType: "post",
                              contentId: widget.postID,
                              reaction: 'like',
                            );
                            _updateReaction('like',widget.isUser);
                          },
                          child: reaction=='like'?SvgPicture.string(
                            fillLikeIcon ,
                          ):SvgPicture.string(emptyLikeIcon),

                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width*0.01
                        ),
                         Text("$likes",
                          style:  TextStyle(
                              fontSize: 9.sp
                          ),

                        ),
                        SizedBox(
                            width: 5.w
                        ),

                        InkWell(
                          onTap: () async {
                            await controller.reactPost(
                              contentType: "post",
                              contentId: widget.postID,
                              reaction: 'dislike',
                            );

                            _updateReaction('dislike',widget.isUser);


                          },
                          child: reaction=='dislike'?SvgPicture.string(
                            fillDislikeIcon ,
                          ):SvgPicture.string(emptyDislikeIcon),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width*0.01
                        ),
                         Text("$disLikes",
                          style:  TextStyle(
                            fontSize: 9.sp,
                          ),

                        ),
                        SizedBox(
                            width: 5.w
                        ),

                        InkWell(
                          child: SvgPicture.string(
                            commentIcon,
                          ),
                          onTap: ()async{

                           await Get.to(()=> CommentScreen(postID: widget.postID,isUser: widget.isUser,));
                          },
                        ),
                        SizedBox(
                            width: 5.w
                        ),
                         Text("${widget.comments}",
                          style:  TextStyle(
                              fontSize: 9.sp
                          ),


                        ),
                      ],
                    )




                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }
}
