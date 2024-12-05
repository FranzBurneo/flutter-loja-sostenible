import 'package:loja_sostenible/models/ods.model.dart';

class Forms {
  final String id;
  final bool visibility;
  final int interactionType;
  final Ods? selectedOds;
  final List<Question> questions;
  final List<Option> options;
  final String description;
  final String title;
  final String userId;
  final DateTime timestamp;
  final UserPost userPost;

  Forms({
    required this.id,
    required this.visibility,
    required this.interactionType,
    this.selectedOds,
    required this.questions,
    required this.options,
    required this.description,
    required this.title,
    required this.userId,
    required this.timestamp,
    required this.userPost,
  });

  factory Forms.fromJson(Map<String, dynamic> json) {
    final selectedOdsJson = json['selectedOds'];
    Ods? selectedOds;
    if (selectedOdsJson is Map<String, dynamic>) {
      selectedOds = Ods.fromJson(selectedOdsJson);
    }

    return Forms(
      id: json["id"],
      visibility: json["visibility"],
      interactionType: json["interactionType"] ?? 1,
      selectedOds: selectedOds,
      questions: List<Question>.from(
          json["questions"].map((x) => Question.fromJson(x))),
      options:
          List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      description: json["description"],
      title: json["title"],
      userId: json["userId"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          json["timestamp"]["_seconds"] * 1000 +
              json["timestamp"]["_nanoseconds"] ~/ 1000000),
      userPost: UserPost.fromJson(json["userPost"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "visibility": visibility,
        "interactionType": interactionType,
        "selectedOds": selectedOds,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "description": description,
        "title": title,
        "userId": userId,
        "timestamp": timestamp.toIso8601String(),
        "userPost": userPost.toJson(),
      };
}

class Option {
  int idQuestion;
  String description;
  int id;

  Option({
    required this.idQuestion,
    required this.description,
    required this.id,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        idQuestion: json["idQuestion"],
        description: json["description"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "idQuestion": idQuestion,
        "description": description,
        "id": id,
      };
}

class Question {
  String question;
  int id;
  int type;

  Question({
    required this.question,
    required this.id,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "id": id,
        "type": type,
      };
}

class UserPost {
  String firstname;
  bool active;
  String userId;
  String email;
  String lastname;
  String organization;
  List<String> rol;
  String avatarImage;

  UserPost({
    required this.firstname,
    required this.active,
    required this.userId,
    required this.email,
    required this.lastname,
    required this.organization,
    required this.rol,
    required this.avatarImage,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        firstname:
            json["firstname"] ?? 'Sin nombre', // Valor por defecto si es null
        active: json["active"] ??
            false, // Valor predeterminado en caso de que active sea null
        userId: json["userId"] ?? '', // Valor por defecto para userId
        email: json["email"] ?? 'Sin correo', // Valor por defecto si es null
        lastname:
            json["lastname"] ?? 'Sin apellido', // Valor por defecto si es null
        organization: json["organization"] ??
            'Sin organización', // Valor por defecto si es null
        rol: json["rol"] != null
            ? List<String>.from(json["rol"].map((x) => x))
            : [], // Si rol es null, devuelve una lista vacía
        avatarImage:
            json["avatarImage"] ?? 'Sin imagen', // Valor por defecto si es null
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "active": active,
        "userId": userId,
        "email": email,
        "lastname": lastname,
        "organization": organization,
        "rol": List<dynamic>.from(rol.map((x) => x)),
        "avatarImage": avatarImage,
      };
}
