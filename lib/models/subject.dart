class Subject {
  final String id;
  final String name;
  final String providerId;
  final String imgId;

  Subject({
    required this.id,
    required this.name,
    required this.providerId,
    required this.imgId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'providerId': providerId,
      'imgId': imgId
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      name: map['name'] as String,
      providerId: map['providerId'] as String,
      imgId: map['imgId'] as String
    );
  }
}
