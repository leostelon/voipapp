import 'package:app/models/group.dart';
import 'package:app/models/user.dart';
import 'package:app/providers/securestorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/widgets.dart';

// Constants
import 'package:app/utils/constants.dart';

//Loacl Host URL
String url = apiurl;
// Secure Storage
SecureStorage _secureStorage = SecureStorage();

enum LoaderStatus { busy, idle }

class ChatProvider with ChangeNotifier {
  List _users = [];
  List get users => _users;

  //Loader State
  static LoaderStatus _loaderStatus = LoaderStatus.idle;
  LoaderStatus get loaderStatus => _loaderStatus;
  void setLoaderStatus(LoaderStatus status) {
    _loaderStatus = status;
    notifyListeners();
  }

  // Get Chat
  Future<void> getChat() async {
    _users = [];
    String token = await _secureStorage.getToken();
    setLoaderStatus(LoaderStatus.busy);
    http.Response response = await http.get(
      "$url/message/chat",
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    var decoded = convert.jsonDecode(response.body);
    decoded['channels'].forEach((user) {
      if (user["private"] != null) {
        var private = user["private"];
        _users.add(User(
          phone: private['phone'].toString(),
          id: private['_id'],
          displayimg: private['displayimg'],
          username: private['username'],
        ));
      } else {
        var group = user["group"];
        List<User> participants = [];
        group['participants'].forEach(
          (p) => participants.add(User(
            phone: p['phone'].toString(),
            id: p['_id'],
            displayimg: p['displayimg'],
            username: p['username'],
          )),
        );
        _users.add(Group(
          id: group['_id'],
          displayimg: group['displayimg'],
          participants: participants,
          author: User(
            phone: group['author']['phone'].toString(),
            id: group['author']['_id'],
            displayimg: group['author']['displayimg'],
            username: group['author']['username'],
          ),
          title: group['title'],
        ));
      }
    });
    setLoaderStatus(LoaderStatus.idle);
  }

  // Search Users
  Future searchUser(String value) async {
    _users = [];
    if (value == "") return getChat();
    setLoaderStatus(LoaderStatus.busy);
    String token = await _secureStorage.getToken();
    print(token);
    http.Response response = await http.get(
      "$url/user?search=$value&limit=10",
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    var decoded = convert.jsonDecode(response.body);
    decoded.forEach((user) {
      _users.add(User(
        phone: user['phone'].toString(),
        id: user['id'],
        displayimg: user['displayimg'],
        username: user['username'],
      ));
    });
    setLoaderStatus(LoaderStatus.idle);
    return decoded;
  }

  handle(data) {
    var response = convert.json.decode(data);
    List<String> availableIds = [];
    _users.forEach((e) => availableIds.add(e.id));
    if (!availableIds.contains(response['userid']['_id'])) {
      _users.add(User(
        phone: response['userid']['phone'].toString(),
        id: response['userid']['_id'],
        displayimg: response['userid']['displayimg'],
        username: response['userid']['username'],
      ));
    }
    notifyListeners();
  }
}
