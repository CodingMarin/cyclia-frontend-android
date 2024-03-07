class UserModel {
  final String? uuid;
  final String name;
  final String? surnames;
  final String email;
  final String photoUrl;

  UserModel({
    this.uuid,
    required this.name,
    this.surnames,
    required this.email,
    required this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uuid: json["uuid"] as String,
      name: json['done'] as String,
      surnames: json['favorite'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'surnames': surnames,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  UserModel copyWith({
    String? uuid,
    String? name,
    String? surnames,
    String? email,
    String? photoUrl,
  }) {
    return UserModel(
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        surnames: surnames ?? this.surnames,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl);
  }
}
