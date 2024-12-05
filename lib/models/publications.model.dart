import 'package:loja_sostenible/models/ods.model.dart';

class Post {
  final String id;
  final DateTime dateTimeEvent;
  bool visibility;
  final Ods? selectedOds;
  final String imageUrl;
  final String place;
  final String title;
  final int type;
  final String userId;
  final String content;
  final DateTime timestamp;
  final UserPost userPost;

  Post({
    required this.id,
    required this.dateTimeEvent,
    required this.visibility,
    this.selectedOds,
    required this.imageUrl,
    required this.place,
    required this.title,
    required this.type,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.userPost,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final selectedOdsJson = json['selectedOds'];
    Ods? selectedOds;
    if (selectedOdsJson is Map<String, dynamic>) {
      selectedOds = Ods.fromJson(selectedOdsJson);
    }

    return Post(
      id: json["id"],
      dateTimeEvent: DateTime.parse(json["DateTimeEvent"]),
      visibility: json["visibility"],
      selectedOds: selectedOds,
      imageUrl: json["imageUrl"],
      place: json["place"],
      title: json["title"],
      type: json["type"],
      userId: json["userId"],
      content: json["content"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          json["timestamp"]["_seconds"] * 1000 +
              json["timestamp"]["_nanoseconds"] ~/ 1000000),
      userPost: UserPost.fromJson(json["userPost"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "DateTimeEvent": dateTimeEvent.toIso8601String(),
        "visibility": visibility,
        "selectedOds": selectedOds,
        "imageUrl": imageUrl,
        "place": place,
        "title": title,
        "type": type,
        "userId": userId,
        "content": content,
        "timestamp": dateTimeEvent.toIso8601String(),
        "userPost": userPost.toJson(),
      };
}

class UserPost {
  String userId;
  String email;
  bool active;
  String firstname;
  String lastname;
  String? avatarImage;
  List<String> rol;

  UserPost({
    required this.userId,
    required this.email,
    required this.active,
    required this.firstname,
    required this.lastname,
    this.avatarImage,
    required this.rol,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        userId: json["userId"],
        email: json["email"],
        active: json["active"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        avatarImage: json["avatarImage"],
        rol: List<String>.from(json["rol"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "active": active,
        "firstname": firstname,
        "lastname": lastname,
        "avatarImage": avatarImage,
        "rol": List<dynamic>.from(rol.map((x) => x)),
      };
}
