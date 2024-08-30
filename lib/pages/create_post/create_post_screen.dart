import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/constants/feelings.dart';
import 'package:googlemap/controller/post_controller/create_post_controller.dart';
import 'package:googlemap/widget/creat_post_widget/feelings/feelings_widget.dart';
import 'package:googlemap/widget/creat_post_widget/paragraph_widget.dart';
import 'package:googlemap/widget/creat_post_widget/set_location_widget.dart';
import 'package:googlemap/widget/text_button_widget/button_widget.dart';

import '../../widget/guest/guest_widget.dart';

class CreatePostScreen extends StatelessWidget {
  bool isUser;
   CreatePostScreen({super.key,required this.isUser});

  @override
  Widget build(BuildContext context) {
    final CreatePostController controller=Get.put(CreatePostController());

    controller.update();
    return Scaffold(
      appBar:AppBar (
        elevation: 0,
        backgroundColor:backgroundColor,
        title: const Text(
            'Write Posts'

        ),
        centerTitle: true,

      ),

      backgroundColor: backgroundColor,
      body: isUser?SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0,right: 28,top: 10),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'post',
                    style: TextStyle(
                      color: colorTextInCreatePostAndHintColor,
                      fontSize: 15.24.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  divider(),
                  ParagraphWidget(controller: controller.bodyController),
                  divider(),
                  Text(
                    'Enter Location',
                    style: TextStyle(
                      color: colorTextInCreatePostAndHintColor,
                      fontSize: 15.24.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    )
                  ),
                  divider(),
                  SetLocationWidget(),
                  divider(),

                  Obx((){
                      Widget widgetToDisplay = Container(); // Default widget

                      final radius = controller.radiusS;
                      if (radius >= 0 && radius <= 100) {
                        widgetToDisplay = FeelingsWidget(name: lv1_name,decs1: lv1_descrption_1,desc2: lv1_descrption_2,
                        op1: lv1_more_descrption_and_id.keys.elementAt(0),op2: lv1_more_descrption_and_id.keys.elementAt(1),
                        op3: lv1_more_descrption_and_id.keys.elementAt(2),mp: lv1_more_descrption_and_id,);
                      } else if (radius <= 500 && radius > 100) {
                        widgetToDisplay =FeelingsWidget(name: lv2_name,decs1: lv2_descrption_1,desc2: lv2_descrption_2,
                          op1: lv2_more_descrption_and_id.keys.elementAt(0),op2: lv2_more_descrption_and_id.keys.elementAt(1),
                          op3: lv2_more_descrption_and_id.keys.elementAt(2),mp: lv2_more_descrption_and_id,);
                      } else if (radius > 500 && radius < 1000) {
                        widgetToDisplay = FeelingsWidget(name: lv3_name,decs1: lv3_descrption_1,desc2: lv3_descrption_2,
                          op1: lv3_more_descrption_and_id.keys.elementAt(0),op2: lv3_more_descrption_and_id.keys.elementAt(1),
                          op3: lv3_more_descrption_and_id.keys.elementAt(2),mp: lv3_more_descrption_and_id,);
                      } else {
                        widgetToDisplay = FeelingsWidget(name: lv4_name,decs1: lv4_descrption_1,desc2: lv4_descrption_2,
                          op1: lv4_more_descrption_and_id.keys.elementAt(0),op2: lv4_more_descrption_and_id.keys.elementAt(1),
                          op3: lv4_more_descrption_and_id.keys.elementAt(2),mp: lv4_more_descrption_and_id,);
                      }

                      return widgetToDisplay;
                    },
                  ),


                  divider(),
                  divider(),

                  Obx(()=> ButtonWidget(
                      text: controller.isLoading.isTrue ? "creating post" : "create post",
                      onTap: () async{
                              await controller.createPost();},
                      color: buttonColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ):const GuestWidget(),
    );
  }
}
