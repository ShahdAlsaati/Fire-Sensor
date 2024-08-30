import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:googlemap/model/home_model.dart';

import '../../constants/constants.dart';
import '../../model/search_model.dart';
import '../../shared/network/local/cache_helper.dart';

class SearchHomeController extends GetxController {
  SearchModel searchModel = SearchModel();
  RxList<Feed> feed = <Feed>[].obs;
  var searchController = TextEditingController();
  final _apiServer = APIServer();
  var isLoading = false.obs;

  Future<void> searchDataWithInternetConnection(String query) async {
    try {
      feed.clear();
      if (query.isEmpty) {
        return;
      }
      isLoading(true);
      final response = await _apiServer.SearchHomeFeed(query).onError((error, stackTrace) {
        print('i am in onError');
        print(error);
        return null;
      });

      if (response == null) {
        return;
      }
      if (response.hasError) {
        print(response.body);
      }
      print("response.statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        print('await r.body');
        print(await response.body);

        if (response.body['message'] == 'success') {
          print('success success success ');

          print('jsonResponse');
          var jsonResponse = json.decode(response.bodyString!);

          searchModel = SearchModel.fromJson(jsonResponse);

          if (searchModel.searchResult != null) {
            feed.addAll(searchModel.searchResult!);  // Add new feed items
          } else {
            print('homeModel.feed is null');
          }
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Method to handle initial load
  Future<void> initialLoad() async {
    await searchDataWithInternetConnection(''); // Load initial data
  }
}

class APIServer extends GetConnect {
  /// [SearchHomeFeed] -- do fetch
  Future<Response?> SearchHomeFeed(String text) async {
    String token ='Bearer ${CacheHelper.getData(key: 'accessToken')??CacheHelper.getData(key: 'guestToken')}';

    var headers = {
      'Authorization': token,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final res = await get(
        '${BASE_URL}read/search?qs=$text',
        headers: headers,
      );
      print(res.body);
      return res;
    } catch (e) {
      return await Future.error(e);
    }
  }
}


