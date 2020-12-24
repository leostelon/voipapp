import 'package:app/screens/ChatList.dart';
import 'package:app/screens/CreateGroup.dart';
import 'package:app/screens/LoginPage.dart';
import 'package:app/screens/Message.dart';
import 'package:app/screens/SignUp.dart';
import 'package:app/screens/test.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings);
    switch (settings.name) {
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'home':
        return MaterialPageRoute(builder: (_) => ChatList());
      case 'test':
        return MaterialPageRoute(builder: (_) => MyApp());
      case 'creategroup':
        return MaterialPageRoute(builder: (_) => CreateGroup());
      case 'message':
        Map data = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => Message(
            username: data['username'],
            id: data['id'],
            displayimg: data['displayimg'],
            channel: data['channel'],
            isGroup: data['isGroup'],
          ),
        );
      case 'signup':
        String phoneno = settings.arguments as String;
        print(phoneno);
        return MaterialPageRoute(
          builder: (_) => SignUp(
            phone: "9600694617",
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Container(
              child: Center(
                child: Text('Check Route Name'),
              ),
            ),
          ),
        );
    }
  }
}
