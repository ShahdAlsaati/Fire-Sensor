import 'home_model.dart';

class UserModel {
  String? message;
  List<int>? codes;
  Map<String, dynamic>? errors;
  int? userId;
  String? username;
  String? email;
  String? createdAt;
  int? totalReports;
  List<Feed>? posts;
  String? cursor;
  bool? lastPage;
  bool? emailVerified;

  UserModel({
    this.message,
    this.codes,
    this.errors,
    this.userId,
    this.username,
    this.email,
    this.createdAt,
    this.totalReports,
    this.posts,
    this.cursor,
    this.lastPage,
    this.emailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    codes = json['codes'].cast<int>();
    errors = json['errors'] ?? {};
    userId = json['userId'] ?? 0;
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    createdAt = json['createdAt'] ?? '';
    totalReports = json['totalReports'] ?? 0;
    if (json['posts'] != null) {
      posts = <Feed>[];
      json['posts'].forEach((v) {
        posts!.add(Feed.fromJson(v));
      });
    }
    cursor = json['cursor'] ?? 0;
    lastPage = json['lastPage'] ?? false;
    emailVerified = json['emailVerified'] ?? false;
  }
}

