import 'dart:convert' as convert;
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

enum LoaderStatus { busy, idle }

class MessageProvider with ChangeNotifier {
  List _messages = [];
  List get messages => _messages;
  String title = "Tahduth";
  void changeTitle() {
    title = 'Changed Title';
    notifyListeners();
  }

  //Loader State
  static LoaderStatus _loaderStatus = LoaderStatus.idle;
  LoaderStatus get loaderStatus => _loaderStatus;
  void setLoaderStatus(LoaderStatus status) {
    _loaderStatus = status;
    notifyListeners();
  }

  Future getMessage(String token, String id,bool isGroup) async {
    setLoaderStatus(LoaderStatus.busy);
    _messages = [];
    http.Response response = await http.get(
      "$apiurl/message/@$id?isgroup=${isGroup.toString()}",
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    var decoded = convert.jsonDecode(response.body);
    decoded['data'].forEach((message) {
      _messages.add({
        'message': message['message'],
        'userid': message['userid'],
        'touserid': message['touserid'],
      });
    });
    notifyListeners();
    setLoaderStatus(LoaderStatus.idle);
    return true;
  }

  void handle(data) {
    var response = convert.json.decode(data);
    _messages.add({
      'message': response['message'],
      'userid': response['userid'],
      'touserid': response['touserid'],
    });
    print(response);
    notifyListeners();
  }
}
