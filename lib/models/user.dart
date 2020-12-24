class User {
  String id;
  String username;
  String displayimg;
  String phone;

  User({
    this.id,
    this.username,
    this.displayimg,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'displayimg': displayimg,
      'phone': phone,
    };
  }
}
