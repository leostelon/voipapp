import 'package:app/components/messagebubble.dart';
import 'package:app/providers/auth.dart';
import 'package:app/providers/message.dart' as MProvider;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesComponent extends StatefulWidget {
  final String id;
  final bool isGroup;
  MessagesComponent({
    @required this.id,
    @required this.isGroup,
  });

  @override
  _MessagesComponentState createState() => _MessagesComponentState();
}

class _MessagesComponentState extends State<MessagesComponent> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      String token = Provider.of<AuthProvider>(context, listen: false).token;
      Provider.of<MProvider.MessageProvider>(context, listen: false).getMessage(
        token,
        widget.id,
        widget.isGroup,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    MProvider.MessageProvider messageProvider =
        Provider.of<MProvider.MessageProvider>(context);

    return Container(
      child: messageProvider.loaderStatus == MProvider.LoaderStatus.busy
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: messageProvider.messages
                    .map((m) => MessageBubble(data: m))
                    .toList(),
              ),
            ),
    );
  }
}
