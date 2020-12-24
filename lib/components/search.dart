import 'package:app/providers/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);

    return TextField(
      onChanged: (String value) async {
        await chatProvider.searchUser(value);
      },
      style: new TextStyle(
        color: Colors.white,
      ),
      decoration: new InputDecoration(
        prefixIcon: new Icon(Icons.search, color: Colors.white),
        hintText: "Search...",
        hintStyle: new TextStyle(color: Colors.white),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
