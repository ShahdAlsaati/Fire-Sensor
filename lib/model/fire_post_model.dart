import 'home_model.dart';

class FirePostModel {
  String? message;
  List<int>? codes;
  List<Feed>? posts;
  String? cursor;
  bool? lastPage;

  FirePostModel({this.message, this.codes, this.posts, this.cursor, this.lastPage});

  FirePostModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    codes = json['codes'].cast<int>();
    if (json['posts'] != null) {
      posts = <Feed>[];
      json['posts'].forEach((v) { posts!.add(new Feed.fromJson(v)); });
    }
    cursor = json['cursor'];
    lastPage = json['lastPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['codes'] = this.codes;

    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    data['cursor'] = this.cursor;
    data['lastPage'] = this.lastPage;
    return data;
  }
}




