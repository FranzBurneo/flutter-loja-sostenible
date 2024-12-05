
class Usuario {
    List<User> users;

    Usuario({
        required this.users,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

class User {
    String id;
    String userId;
    String email;
    bool active;
    String avatarImage;
    List<String> rol;
    String firstname;
    String organization;
    String lastname;

    User({
        required this.id,
        required this.userId,
        required this.email,
        required this.active,
        required this.avatarImage,
        required this.rol,
        required this.firstname,
        required this.organization,
        required this.lastname,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userId: json["userId"],
        email: json["email"],
        active: json["active"],
        avatarImage: json["avatarImage"],
        rol: List<String>.from(json["rol"].map((x) => x)),
        firstname: json["firstname"],
        organization: json["organization"],
        lastname: json["lastname"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "email": email,
        "active": active,
        "avatarImage": avatarImage,
        "rol": List<dynamic>.from(rol.map((x) => x)),
        "firstname": firstname,
        "organization": organization,
        "lastname": lastname,
    };
}
