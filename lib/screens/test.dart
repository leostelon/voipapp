import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:app/providers/message.dart';
import 'package:app/providers/auth.dart' as AProvider;
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel: IOWebSocketChannel.connect(
            'ws://192.168.0.3:3000/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZmUwZDdmNDVmNDM1ZTUxYzA1ZGY1MjUiLCJpYXQiOjE2MDg2MTQ4Mzl9.EONzGzdFtz2ip94F6D5zUcwr6HeCbNd9wVYXeENi6O8'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MessageProvider>(context, listen: false).getMessage(
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZmUwZDdmNDVmNDM1ZTUxYzA1ZGY1MjUiLCJpYXQiOjE2MDg1NzExMjl9.lucTPdR0u1w9uI4rHEuMvTnd45mZSQd8U6xFnr3xlX4',
          "5fe032829a9b5b5f6cf9b646",true);
    });
  }

  @override
  Widget build(BuildContext context) {
    MessageProvider messageProvider = Provider.of<MessageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _sendMessage(messageProvider),
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: messageProvider.loaderStatus == LoaderStatus.busy
          ? Text('Loading')
          : Text(messageProvider.messages.length.toString()),
    );
  }

  void _sendMessage(MessageProvider messageProvider) {
    messageProvider.handle({'message': 'This is a message'});
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
