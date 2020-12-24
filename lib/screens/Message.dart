import 'package:app/components/message.dart';
import 'package:app/components/send.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

List<String> messageList = [];
String tokenData;

class Message extends StatelessWidget {
  final username;
  final displayimg;
  final id;
  final channel;
  final bool isGroup;
  Message({
    @required this.username,
    @required this.displayimg,
    @required this.id,
    @required this.channel,
    @required this.isGroup,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
            ),
            SizedBox(
              width: 8,
            ),
            Text(username),
          ],
        ),
        backgroundColor: AppColors.colorBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesComponent(
              id: id,
              isGroup: isGroup,
            ),
          ),
          SendComponent(
            touserid: id,
            channel: channel,
            isGroup:isGroup,
          ),
        ],
      ),
    );
  }
}
