import 'package:app/providers/securestorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

// Constants
import 'package:app/utils/constants.dart';

import 'package:app/models/user.dart';
import 'package:flutter/widgets.dart';

//Loacl Host URL
String url = apiurl;

enum LoaderStatus { busy, idle }
// Secure Storage
SecureStorage secureStorage = SecureStorage();

class AuthProvider with ChangeNotifier {
  //Global User
  User _user;
  //Get User
  User get user {
    return _user;
  }

  //Global Token
  String _token;
  //Get Token
  String get token => _token;
  // Set Token
  Future<void> setToken() async {
    _token = await secureStorage.getToken();
    _user = await secureStorage.user;
    notifyListeners();
  }

  //Loader State
  static LoaderStatus _loaderStatus = LoaderStatus.idle;
  LoaderStatus get loaderStatus => _loaderStatus;
  void setLoaderStatus(LoaderStatus status) {
    _loaderStatus = status;
    notifyListeners();
  }

  //Login or Create
  Future login({image, username, phone}) async {
    setLoaderStatus(LoaderStatus.busy);
    http.Response response = await http.post(
      "$url/user",
      body: convert.jsonEncode({
        "phone": phone,
        "username": username,
      }),
      headers: {
        "Content-type": "application/json",
      },
    );
    var decoded = convert.jsonDecode(response.body);
    var user = decoded["user"];
    await secureStorage.signin(
      decoded['token'],
      User(
        displayimg: user["displayimg"],
        phone: user["phone"].toString(),
        id: user["_id"],
        username: user["username"],
      ),
    );
    print(response.statusCode);
    setLoaderStatus(LoaderStatus.idle);
    return {"statusCode": response.statusCode, "data": decoded};
  }
}
