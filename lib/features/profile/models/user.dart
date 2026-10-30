class User {
  const User({
    this.id,
    this.provider,
    this.email,
    this.name,
    this.avatar,
    this.createdAt,
  });

  final String? id;
  final String? provider;
  final String? email;
  final String? name;
  final String? avatar;
  final DateTime? createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      provider: json['provider'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'email': email,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
