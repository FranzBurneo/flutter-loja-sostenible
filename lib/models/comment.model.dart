class CommentsP {
  final String id;
  final String postId;
  final String content;
  final DateTime timestamp;
  final User2 user;
  final List<Reply> replies;

  CommentsP({
    required this.id,
    required this.postId,
    required this.content,
    required this.timestamp,
    required this.user,
    required this.replies,
  });

  factory CommentsP.fromJson(Map<String, dynamic> json) => CommentsP(
        id: json["id"],
        postId: json["postId"],
        content: json["content"],
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            json["timestamp"]["_seconds"] * 1000 +
                json["timestamp"]["_nanoseconds"] ~/ 1000000),
        user: User2.fromJson(json["user"]),
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "content": content,
        "timestamp": timestamp.toIso8601String(),
        "user": user.toJson(),
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
      };
}

class Reply {
  final String id;
  final String content;
  final DateTime timestamp;
  final User2 user;
  final String nameUserReplied;

  Reply({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.user,
    required this.nameUserReplied,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["id"],
        content: json["content"],
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            json["timestamp"]["_seconds"] * 1000 +
                json["timestamp"]["_nanoseconds"] ~/ 1000000),
        user: User2.fromJson(json["user"]),
        nameUserReplied: json["nameUserReplied"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "timestamp": timestamp.toIso8601String(),
        "user": user.toJson(),
        "nameUserReplied": nameUserReplied,
      };
}

class User2 {
  String id;
  String firstname;
  String lastname;
  String profileImage;

  User2({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.profileImage,
  });

  factory User2.fromJson(Map<String, dynamic> json) => User2(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "profileImage": profileImage,
      };
}
