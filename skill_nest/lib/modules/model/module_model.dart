class Modules {
  final int id;
  final String title;
  final String description;

  Modules({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Modules.fromJson(Map<String, dynamic> json) {
    return Modules(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
