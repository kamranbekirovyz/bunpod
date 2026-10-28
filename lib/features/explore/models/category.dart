class Category {
  const Category({this.id, this.name});

  final int? id;
  final String? name;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}
