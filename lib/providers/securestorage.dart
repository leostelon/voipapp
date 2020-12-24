import 'package:app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage extends ChangeNotifier {
  //flutter_secure_storage
  final _storage = new FlutterSecureStorage();

  //Instance of the Storage
  static final instance = new FlutterSecureStorage();

  //Add Token
  Future _addToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  //Get Token
  Future<String> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future signin(String token, User user) async {
    await _storage.write(key: 'displayimg', value: user.displayimg);
    await _storage.write(key: 'id', value: user.id);
    await _storage.write(key: 'phone', value: user.phone);
    await _storage.write(key: 'username', value: user.username);
    await _addToken(token);
  }

  //Get token(used in splash screen for checking token availablity).
  Future<User> get user async {
    String id = await _storage.read(key: "id");
    String phone = await _storage.read(key: "phone");
    String username = await _storage.read(key: "username");
    String displayimg = await _storage.read(key: "displayimg");
    return User(
      phone: phone,
      id: id,
      username: username,
      displayimg: displayimg,
    );
  }

  //Logout
  Future<void> removeToken() async {
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
