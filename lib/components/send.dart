import 'dart:convert';

import 'package:flutter/material.dart';

class SendComponent extends StatelessWidget {
  final touserid;
  final channel;
  final isGroup;
  SendComponent({
    @required this.touserid,
    @required this.isGroup,
    @required this.channel,
  });
  @override
  Widget build(BuildContext context) {
    TextEditingController messageEditingController =
        new TextEditingController();

    return //Send Button
        Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.blueAccent),
        ),
      ),
      child: TextField(
        controller: messageEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Type something...',
          suffixIcon: IconButton(
            icon: Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () {
              if (messageEditingController.text.length > 0) {
                channel.sink.add(
                  json.encode(
                    {
                      "touserid": touserid,
                      "message": messageEditingController.text,
                      "type": isGroup ? 'group' : 'private'
                    },
                  ),
                );
                messageEditingController.text = '';
              }
            },
          ),
        ),
      ),
    );
  }
}
