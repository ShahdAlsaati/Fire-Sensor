import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserManualWidget extends StatelessWidget {

  String url;
  String dis;
  double? width= 80;
  double? height= 80;

  UserManualWidget({super.key,required this.url,required this.dis,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 28.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dis,
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            Image(image: AssetImage(url),width: width!.w??80.w,height: height!.h??80.h,),


          ],
        ),
      ),
    );
  }
}
