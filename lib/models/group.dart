import 'package:app/models/user.dart';

class Group {
  String id;
  String title;
  User author;
  String displayimg;
  List<User> participants;
  Group({
    this.id,
    this.participants,
    this.author,
    this.displayimg,
    this.title,
  });

  getAuthor() {
    print('Get Author is ready');
  }
}
