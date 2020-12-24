import 'package:app/providers/auth.dart';
import 'package:app/providers/chat.dart';
import 'package:app/providers/message.dart';
import 'package:app/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => AuthProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ChatProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => MessageProvider(),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: 'login',
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          );
        }
        return CupertinoActivityIndicator();
      },
    );
  }
}
