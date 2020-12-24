import 'dart:convert';

import 'package:app/components/search.dart';
import 'package:app/models/group.dart';
import 'package:app/providers/auth.dart' as AProvider;
import 'package:app/providers/chat.dart' as CProvider;
import 'package:app/providers/message.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import '../utils/app_colors.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget appBarTitle = new Text("Tahduth");
  Icon actionIcon = new Icon(Icons.search);
  IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    AProvider.AuthProvider authProvider =
        Provider.of<AProvider.AuthProvider>(context, listen: false);
    channel = IOWebSocketChannel.connect(
        'ws://192.168.0.3:3000/${authProvider.token}');
    MessageProvider messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    CProvider.ChatProvider chatProvider =
        Provider.of<CProvider.ChatProvider>(context, listen: false);
    channel.stream.listen((event) {
      messageProvider.handle(event);
      chatProvider.handle(event);
    });
    Provider.of<CProvider.ChatProvider>(context, listen: false).getChat();
  }

  @override
  Widget build(BuildContext context) {
    CProvider.ChatProvider chatProvider =
        Provider.of<CProvider.ChatProvider>(context);
    MessageProvider messageProvider = Provider.of<MessageProvider>(context);
    AProvider.AuthProvider authProvider =
        Provider.of<AProvider.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Image.asset("assets/drawer.ico"),
        ),
        title: appBarTitle,
        actions: [
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = SearchComponent();
                } else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("Tahduth");
                }
              });
            },
          )
        ],
        backgroundColor: AppColors.colorBlue,
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.colorBlue,
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        child: Icon(
                          Icons.account_circle,
                          size: 64,
                        ),
                        radius: 35.0,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Text(
                    //   authProvider.user.username,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: AppColors.colorBlue,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(color: AppColors.colorWhite),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.group,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text('New Group',
                    style: TextStyle(color: AppColors.colorWhite)),
                onTap: () {
                  Navigator.pushNamed(context, 'creategroup');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.live_tv,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text('New Channel',
                    style: TextStyle(color: AppColors.colorWhite)),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.star_border,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text('Saved Messages',
                    style: TextStyle(color: AppColors.colorWhite)),
                onTap: () {
                  // Update the state of the app._controller.text
                  // ...
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.phone_in_talk,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text('Calls',
                    style: TextStyle(color: AppColors.colorWhite)),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text('Contacts',
                    style: TextStyle(color: AppColors.colorWhite)),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text('Setting',
                    style: TextStyle(color: AppColors.colorWhite)),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text('Invite',
                    style: TextStyle(color: AppColors.colorWhite)),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('ok');
          messageProvider.handle({"message": "This is a message"});
        },
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
      body: Container(
        child: chatProvider.loaderStatus == CProvider.LoaderStatus.busy
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : chatProvider.users.length != 0
                ? ListView.builder(
                    itemCount: chatProvider.users.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(8),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'message',
                            arguments: {
                              "username":
                                  chatProvider.users[i].runtimeType != Group
                                      ? chatProvider.users[i].username
                                      : chatProvider.users[i].title,
                              "id": chatProvider.users[i].id,
                              "displayimg": chatProvider.users[i].displayimg,
                              "channel": channel,
                              "isGroup":
                                  chatProvider.users[i].runtimeType == Group
                                      ? true
                                      : false,
                            },
                          );
                        },
                        tileColor: Colors.grey[100],
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            apiurl + chatProvider.users[i].displayimg,
                          ),
                          radius: 32,
                        ),
                        title: Text(
                          chatProvider.users[i].runtimeType != Group
                              ? chatProvider.users[i].username
                              : chatProvider.users[i].title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // subtitle: Text('last message'),
                      );
                    },
                  )
                : Center(
                    child: Text('You haven\'t texted anyone.'),
                  ),
      ),
    );
  }
}
