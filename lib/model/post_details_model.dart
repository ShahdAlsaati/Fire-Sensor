class PostModel {
  String? message;
  List<int>? codes;
  List<Comments>? comments;
  String? cursor;
  Comments? comment;
  int? userId;
  String? username;
  int? numberOfComments;
  NumberOfReactions? numberOfReactions;
  int? fireId;
  bool? didComment;
  bool? didReact;
  String? reaction;
  String? postBody;
  int? feelingId;
  String? createdAt;
  bool? lastPage;

  PostModel(
      {this.message,
        this.codes,
        this.comments,
        this.cursor,
        this.comment,
        this.userId,
        this.username,
        this.numberOfComments,
        this.numberOfReactions,
        this.fireId,
        this.didComment,
        this.didReact,
        this.reaction,
        this.postBody,
        this.feelingId,
        this.createdAt,
        this.lastPage});

  PostModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    codes = json['codes'].cast<int>();
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    cursor = json['cursor'];
    comment =
    json['comment'] != null ? new Comments.fromJson(json['comment']) : null;
    userId = json['userId'];
    username = json['username'];
    numberOfComments = json['numberOfComments'];
    numberOfReactions = json['numberOfReactions'] != null
        ? new NumberOfReactions.fromJson(json['numberOfReactions'])
        : null;
    fireId = json['fireId'];
    didComment = json['didComment'];
    didReact = json['didReact'];
    reaction = json['reaction'];
    postBody = json['postBody'];
    feelingId = json['feelingId'];
    createdAt = json['createdAt'];
    lastPage = json['lastPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['codes'] = this.codes;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['cursor'] = this.cursor;
    if (this.comment != null) {
      data['comment'] = this.comment!.toJson();
    }
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['numberOfComments'] = this.numberOfComments;
    if (this.numberOfReactions != null) {
      data['numberOfReactions'] = this.numberOfReactions!.toJson();
    }
    data['fireId'] = this.fireId;
    data['didComment'] = this.didComment;
    data['didReact'] = this.didReact;
    data['reaction'] = this.reaction;
    data['postBody'] = this.postBody;
    data['feelingId'] = this.feelingId;
    data['createdAt'] = this.createdAt;
    data['lastPage'] = this.lastPage;
    return data;
  }

  PostModel copyWith({
    String? message,
    List<int>? codes,
    List<Comments>? comments,
    String? cursor,
    Comments? comment,
    int? userId,
    String? username,
    int? numberOfComments,
    NumberOfReactions? numberOfReactions,
    int? fireId,
    bool? didComment,
    bool? didReact,
    String? reaction,
    String? postBody,
    int? feelingId,
    String? createdAt,
    bool? lastPage,
  }) {
    return PostModel(
      message: message ?? this.message,
      codes: codes ?? this.codes,
      comments: comments ?? this.comments,
      cursor: cursor ?? this.cursor,
      comment: comment ?? this.comment,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      numberOfComments: numberOfComments ?? this.numberOfComments,
      numberOfReactions: numberOfReactions ?? this.numberOfReactions,
      fireId: fireId ?? this.fireId,
      didComment: didComment ?? this.didComment,
      didReact: didReact ?? this.didReact,
      reaction: reaction ?? this.reaction,
      postBody: postBody ?? this.postBody,
      feelingId: feelingId ?? this.feelingId,
      createdAt: createdAt ?? this.createdAt,
      lastPage: lastPage ?? this.lastPage,
    );
  }
}

class Comments {
  int? userId;
  String? username;
  String? commentBody;
  NumberOfReactions? numberOfReactions;
  String? createdAt;
  int? commentId;
  bool? didReact;
  String? reaction;

  Comments({
    this.userId,
    this.username,
    this.commentBody,
    this.numberOfReactions,
    this.createdAt,
    this.commentId,
    this.didReact,
    this.reaction,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    commentBody = json['commentBody'];
    numberOfReactions = json['numberOfReactions'] != null ? NumberOfReactions.fromJson(json['numberOfReactions']) : null;
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

  Comments copyWith({
    int? userId,
    String? username,
    String? commentBody,
    NumberOfReactions? numberOfReactions,
    String? createdAt,
    int? commentId,
    bool? didReact,
    String? reaction,
  }) {
    return Comments(
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
