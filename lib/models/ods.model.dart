class Ods {
    final String id;
    final String name;
    final int number;
    final String color;
    final String toShow;
    final String title;
    final String description;
    final String cardImage;
    final String route;
    final String largeDescription;
    final String? logoImage;
    final String? logoImg;

    Ods({
        required this.id,
        required this.name,
        required this.number,
        required this.color,
        required this.toShow,
        required this.title,
        required this.description,
        required this.cardImage,
        required this.route,
        required this.largeDescription,
        this.logoImage,
        this.logoImg,
    });

    factory Ods.fromJson(Map<String, dynamic> json) => Ods(
        id: json["id"] ?? '',
        name: json["name"],
        number: json["number"],
        color: json["color"],
        toShow: json["toShow"],
        title: json["title"],
        description: json["description"],
        cardImage: json["cardImage"],
        route: json["route"],
        largeDescription: json["large_description"],
        logoImage: json["logoImage"],
        logoImg: json["logoImg"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number": number,
        "color": color,
        "toShow": toShow,
        "title": title,
        "description": description,
        "cardImage": cardImage,
        "route": route,
        "large_description": largeDescription,
        "logoImage": logoImage,
        "logoImg": logoImg,
    };
}
