import 'package:app/providers/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final data;
  MessageBubble({@required this.data});
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: authProvider.user.id == data['userid']['_id']
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: authProvider.user.id == data['userid']['_id']
                  ? Colors.blueAccent[100]
                  : Colors.blueAccent[100],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
                topRight: authProvider.user.id != data['userid']['_id']
                    ? Radius.circular(8)
                    : Radius.zero,
                topLeft: authProvider.user.id == data['userid']['_id']
                    ? Radius.circular(8)
                    : Radius.zero,
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: authProvider.user.id != data['userid']['_id']
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  data['userid']['username'].toUpperCase(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                Text(
                  data['message'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
