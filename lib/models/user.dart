class AppUser {
  final String id;
  final String name;
  final String email;
  final List<String> favoritePointsIds;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.favoritePointsIds
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'favoritePointsIds': favoritePointsIds
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['name'] as String,
      favoritePointsIds: map['favoritePointsIds'] as List<String>
    );
  }
}
