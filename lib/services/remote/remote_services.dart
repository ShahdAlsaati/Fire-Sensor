// import 'dart:convert';
//
// import 'package:get/get.dart';
//
// import '../../constants/constants.dart';
// import '../../shared/network/local/cache_helper.dart';
//
//
// class APIServer {
//
//   RemoteServices remoteServices = RemoteServices();
//
//   /// [reactPostComment] -- do react
//   Future<Response?> reactPostComment({contentID, contentType, reaction}) async {
//     String userId = await CacheHelper.getData(key: 'userId');
//
//     var headers = {
//       'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//     var body = json.encode(
//         {"userId": double.parse(userId),
//
//           "contentType": contentType,
//           "reaction": reaction,
//           "contentId": contentID
//         });
//     remoteServices.postFromRemoteServices(
//         url: '${BASE_URL}create/reaction', body: body, headers: headers);
//   }
//
//   /// [fetchHomeFeed] -- do fetch
//   Future<Response?> fetchHomeFeed(int cursor) async {
//     // double id=double.parse(id1);
//
//     var headers = {
//       'Authorization': 'Bearer ${CacheHelper.getData(key: 'accessToken')}',
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//     remoteServices.getFromRemoteServices(
//         url: '${BASE_URL}read/home?nop=true&ps=5&${cursor}', headers: headers);
//   }
//
//   Future<Response?> refreshToken() async {
//     var headers = {
//       'Authorization': 'Bearer ${CacheHelper.getData(key: 'refreshToken')}',
//       'Content-Type': 'application/json',
//     };
//     remoteServices.postFromRemoteServices(url: '${BASE_URL}refresh-token',body:  {},headers: headers);
//   }
// }
//
// class RemoteServices extends GetConnect{
//
//   Future<Response?>  getFromRemoteServices({
//     required url,
//     required headers,
// }) async {
//     try {
//       // send post request
//       final res = await get(
//         url,
//         headers: headers,
//       );
//
//       print(res.body);
//       return res;
//     } catch (e) {
//       return await Future.error(e);
//     }
//   }
//   Future<Response?>  postFromRemoteServices({
//     required url,
//     required headers,
//     required body
//   }) async {
//     try {
//       // send post request
//       final res = await post(
//         url,
//         body,
//         headers: headers
//
//       );
//       print(res.body);
//       return res;
//     } catch (e) {
//       return await Future.error(e);
//     }
//   }
// }
