class UserDetails {
  int id;
  String photoName;

  UserDetails({required this.id, required this.photoName});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'photoName': photoName};
    return map;
  }
}
