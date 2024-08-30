// import 'package:get/get.dart';
//
// import '../../../controller/main_page_controller/event_controller.dart';
// import '../local/cache_helper.dart';
//
// class GetXConnecterHelper extends GetConnect {
//   APIServer eventController = APIServer();
//   Future<Response> getData({
//     required String url,
//     // String? token,
//   }) async {
//   var token= await eventController.refreshToken();
//     var headers = {
//       'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//     final res = await get(
//       url,
//       headers: headers,
//     );
//     return res;
//   }
//
//   Future<Response> postData({
//     required String url,
//     Map<String, dynamic>? body,
//     String? token,
//   }) async {
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': '$token',
//     };
//     final res = await post(
//       url,
//       body ?? {},
//       headers: headers,
//     );
//     return res;
//   }
//
//   Future<Response> putData({
//     required String url,
//     Map<String, dynamic>? body,
//     String? token,
//   }) async {
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': '$token',
//     };
//     final res = await put(
//       url,
//       body ?? {},
//       headers: headers,
//     );
//     return res;
//   }
// }
