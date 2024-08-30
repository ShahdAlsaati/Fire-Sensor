import 'package:flutter/widgets.dart';
import '../shared/network/local/cache_helper.dart';

String myPCIP='192.168.1.11';

String antherIP='192.168.137.1';

String BASE_URL="http://$myPCIP:2500/mobile-app/";

Widget divider(){
  return const SizedBox(
    height: 10,
  );
}

logout()async{
  await CacheHelper.removeData(key: 'id');
  await CacheHelper.removeData(key: 'refreshToken');
  await CacheHelper.removeData(key: 'accessToken');
  await CacheHelper.removeData(key: 'guestToken');
  await CacheHelper.removeData(key: 'email');
  await CacheHelper.removeData(key: 'username');

}