import 'package:googlemap/model/home_model.dart';

class SearchModel {
  String? message;
  List<int>? codes;
  List<Feed>? searchResult;

  SearchModel({this.message, this.codes, this.searchResult});

  SearchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    codes = json['codes'].cast<int>();
    if (json['searchResult'] != null) {
      searchResult = <Feed>[];
      json['searchResult'].forEach((v) {
        searchResult!.add(Feed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['codes'] = codes;
    if (searchResult != null) {
      data['searchResult'] = searchResult!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


