import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';
import 'package:googlemap/constants/constants.dart';
import 'package:googlemap/controller/report_controller/send_report_controller.dart';
import 'package:googlemap/widget/report_fire_widget/report_button_fire_widget.dart';
import 'package:googlemap/widget/text_button_widget/button_widget.dart';


class SendReportScreen extends StatelessWidget {
   SendReportScreen({super.key});
  SendReportController sendReportController=Get.put(SendReportController());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },),
      ),

      backgroundColor: backgroundColor,
      body: Padding(

        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Center(
                child: Text('Need emergency fire services ?',
                  textAlign:TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,

                  ),
                )
            ),             SizedBox(
              height: 140.h,
            ),


             SizedBox(
              height: 20.h,
            ),
            InkWell(

                child: const ReportButtonFireWidget(),
              onTap: () async{
                await  sendReportController.makePhoneCall("00000");

                // Get.bottomSheet(
                //
                //   SingleChildScrollView(
                //     child: SizedBox(
                //       height: MediaQuery.of(context).size.height*0.4,
                //     width: double.infinity,
                //                      child: Padding(
                //      padding: const EdgeInsets.all(12.0),
                //      child: Column(
                //        mainAxisAlignment: MainAxisAlignment.center,
                //        crossAxisAlignment: CrossAxisAlignment.start,
                //        children: [
                //
                //           Text('Emergcy call',style: TextStyle(
                //            fontSize: 26.sp
                //          ),),
                //          divider(),
                //           Text('set size',style: TextStyle(
                //            color: postBodyTextColor,
                //            fontSize: 16.sp
                //          ),),
                //          divider(),
                //          Obx(() => Container(
                //            decoration: BoxDecoration(
                //              color: textFormFieldColor,
                //              borderRadius: BorderRadius.circular(20),
                //              border: Border.all(
                //                color: Colors.black,
                //                width: 1.0,
                //              ),
                //            ),
                //
                //            width: MediaQuery.of(context).size.width*0.95,
                //
                //            child: Row(
                //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //              children: [
                //                Center(
                //                  child: Padding(
                //                    padding: const EdgeInsets.all(18.0),
                //                    child: Text(sendReportController.selectedOption.value,
                //                     style: const TextStyle(
                //                          color: postBodyTextColor
                //                      ),),
                //                  ), // Display selected option
                //                ),
                //                DropdownButton(
                //                  icon: const Icon(Icons.keyboard_arrow_down,
                //                    color: postBodyTextColor,
                //                  ),
                //                  iconSize: 32.r,
                //                  elevation: 4,
                //                  underline: Container(height: 0,),
                //                  items: sendReportController.feeilingsList.map<DropdownMenuItem<String>>((String? value)
                //                  {
                //                    return DropdownMenuItem<String>(
                //                      value: value.toString(),
                //                      child: Text(
                //                        value.toString(),
                //                        style: const TextStyle(
                //                            color: Colors.grey
                //                        ),
                //                      ),
                //                    );
                //                  }).toList(),
                //                  onChanged: (String? newValue) {
                //                    // print(newValue);
                //                    sendReportController.updateSelectedValue(newValue);
                //                    //_controller.update();
                //
                //                  },
                //                ),
                //              ],
                //            ),
                //          )),
                //          divider(),
                //          divider(),   divider(),   divider(),
                //          ButtonWidget(text: 'send', onTap: (){}, color: buttonColor)
                //        ],
                //      ),
                //                      ),
                //                     ),
                //   ),
                // backgroundColor: backgroundColor,
                //
                // );
              },
            ),



          ],
        ),
      ),
    );
  }
}
