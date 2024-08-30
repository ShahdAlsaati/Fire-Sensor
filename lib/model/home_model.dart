class HomeModel {
  String? message;
  List<int>? codes;
  List<Feed>? feed;
  String? cursor;
  int? pageSize;
  bool? lastPage;

  HomeModel({
    this.message,
    this.codes,
    this.feed,
    this.cursor,
    this.pageSize,
    this.lastPage,
  });

  HomeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    codes = json['codes'].cast<int>();
    if (json['feed'] != null) {
      feed = <Feed>[];
      json['feed'].forEach((v) {
        feed!.add(Feed.fromJson(v));
      });
    }
    cursor = json['cursor'];
    pageSize = json['pageSize'];
    lastPage = json['lastPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['codes'] = codes;
    if (feed != null) {
      data['feed'] = feed!.map((v) => v.toJson()).toList();
    }
    data['cursor'] = cursor;
    data['pageSize'] = pageSize;
    data['lastPage'] = lastPage;
    return data;
  }

  HomeModel copyWith({
    String? message,
    List<int>? codes,
    List<Feed>? feed,
    String? cursor,
    int? pageSize,
    bool? lastPage,
  }) {
    return HomeModel(
      message: message ?? this.message,
      codes: codes ?? this.codes,
      feed: feed ?? this.feed,
      cursor: cursor ?? this.cursor,
      pageSize: pageSize ?? this.pageSize,
      lastPage: lastPage ?? this.lastPage,
    );
  }
}

class Feed {
  int? userId;
  int? postId;
  String? username;
  int? feelingId;
  int? fireId;
  String? postBody;
  NumberOfReactions? numberOfReactions;
  String? createdAt;
  int? numberOfComments;
  bool? didComment;
  Comment? comment;
  bool? didReact;
  String? reaction;

  Feed({
    this.userId,
    this.postId,
    this.username,
    this.feelingId,
    this.fireId,
    this.postBody,
    this.numberOfReactions,
    this.createdAt,
    this.numberOfComments,
    this.didComment,
    this.comment,
    this.didReact,
    this.reaction,
  });

  Feed.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    postId = json['postId'];
    username = json['username'];
    feelingId = json['feelingId'];
    fireId = json['fireId'];
    postBody = json['postBody'];
    numberOfReactions = json['numberOfReactions'] != null
        ? NumberOfReactions.fromJson(json['numberOfReactions'])
        : null;
    createdAt = json['createdAt'];
    numberOfComments = json['numberOfComments'];
    didComment = json['didComment'];
    comment = json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    didReact = json['didReact'];
    reaction = json['reaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['postId'] = postId;
    data['username'] = username;
    data['feelingId'] = feelingId;
    data['fireId'] = fireId;
    data['postBody'] = postBody;
    if (numberOfReactions != null) {
      data['numberOfReactions'] = numberOfReactions!.toJson();
    }
    data['createdAt'] = createdAt;
    data['numberOfComments'] = numberOfComments;
    data['didComment'] = didComment;
    if (comment != null) {
      data['comment'] = comment!.toJson();
    }
    data['didReact'] = didReact;
    data['reaction'] = reaction;
    return data;
  }

  Feed copyWith({
    int? userId,
    int? postId,
    String? username,
    int? feelingId,
    int? fireId,
    String? postBody,
    NumberOfReactions? numberOfReactions,
    String? createdAt,
    int? numberOfComments,
    bool? didComment,
    Comment? comment,
    bool? didReact,
    String? reaction,
  }) {
    return Feed(
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      feelingId: feelingId ?? this.feelingId,
      fireId: fireId ?? this.fireId,
      postBody: postBody ?? this.postBody,
      numberOfReactions: numberOfReactions ?? this.numberOfReactions,
      createdAt: createdAt ?? this.createdAt,
      numberOfComments: numberOfComments ?? this.numberOfComments,
      didComment: didComment ?? this.didComment,
      comment: comment ?? this.comment,
      didReact: didReact ?? this.didReact,
      reaction: reaction ?? this.reaction,
    );
  }
}

class NumberOfReactions {
  int? like;
  int? dislike;

  NumberOfReactions({this.like, this.dislike});

  NumberOfReactions.fromJson(Map<String, dynamic> json) {
    like = json['like'];
    dislike = json['dislike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['like'] = like;
    data['dislike'] = dislike;
    return data;
  }

  NumberOfReactions copyWith({
    int? like,
    int? dislike,
  }) {
    return NumberOfReactions(
      like: like ?? this.like,
      dislike: dislike ?? this.dislike,
    );
  }
}

class Comment {
  int? userId;
  String? username;
  String? commentBody;
  NumberOfReactions? numberOfReactions;
  String? createdAt;
  int? commentId;
  bool? didReact;
  String? reaction;

  Comment({
    this.userId,
    this.username,
    this.commentBody,
    this.numberOfReactions,
    this.createdAt,
    this.commentId,
    this.didReact,
    this.reaction,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    commentBody = json['commentBody'];
    numberOfReactions = json['numberOfReactions'] != null
        ? NumberOfReactions.fromJson(json['numberOfReactions'])
        : null;
    createdAt = json['createdAt'];
    commentId = json['commentId'];
    didReact = json['didReact'];
    reaction = json['reaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['username'] = username;
    data['commentBody'] = commentBody;
    if (numberOfReactions != null) {
      data['numberOfReactions'] = numberOfReactions!.toJson();
    }
    data['createdAt'] = createdAt;
    data['commentId'] = commentId;
    data['didReact'] = didReact;
    data['reaction'] = reaction;
    return data;
  }

  Comment copyWith({
    int? userId,
    String? username,
    String? commentBody,
    NumberOfReactions? numberOfReactions,
    String? createdAt,
    int? commentId,
    bool? didReact,
    String? reaction,
  }) {
    return Comment(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      commentBody: commentBody ?? this.commentBody,
      numberOfReactions: numberOfReactions ?? this.numberOfReactions,
      createdAt: createdAt ?? this.createdAt,
      commentId: commentId ?? this.commentId,
      didReact: didReact ?? this.didReact,
      reaction: reaction ?? this.reaction,
    );
  }
}
