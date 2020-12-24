import 'package:app/providers/auth.dart';
import 'package:app/utils/app_colors.dart';
import 'package:app/utils/raised_button.dart';
import 'package:flutter/material.dart';

import 'dart:convert' as convert;
import 'package:app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController _titleEditingController = TextEditingController();

  bool _isLoading = false;
  _createGroup(String token) async {
    if (_titleEditingController.value.text == '') return;
    setState(() {
      _isLoading = !_isLoading;
    });
    http.Response response = await http.post(
      "$apiurl/group",
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: convert.json.encode({
        "title": _titleEditingController.value.text,
      }),
    );
    var decoded = convert.jsonDecode(response.body);
    print(decoded);
    setState(() {
      _isLoading = !_isLoading;
    });
    Navigator.popAndPushNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        backgroundColor: AppColors.colorBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Group Name',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _titleEditingController,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "Enter your group name...",
                  border: InputBorder.none,
                ),
              ),
            ),
            MyRaisedButton(
              onPressed: (context) => _createGroup(authProvider.token),
              title: 'Create Group',
              textColor: Colors.white,
              loading: _isLoading,
              buttonColor: AppColors.colorBlue,
            ),
          ],
        ),
      ),
    );
  }
}
