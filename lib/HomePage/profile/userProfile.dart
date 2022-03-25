import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:library_management/HomePage/Home.dart';
import '../../Constants.dart';
import '../../Network.dart';
import 'placeholderTemp.dart';

class placeHolder extends StatelessWidget {
  String username;
  placeHolder({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Container(
        child: Text(username),
      ),
    );
  }
}

class userPopUpProfileButton extends StatefulWidget {
  String username;
  String id;
  userStatus curstatus;
  userPopUpProfileButton(
      {required this.username, required this.curstatus, required this.id});
  @override
  _userPopUpProfileButtonState createState() => _userPopUpProfileButtonState();
}

class _userPopUpProfileButtonState extends State<userPopUpProfileButton> {
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();
  var confirmPassController = TextEditingController();

  void fetch() async {
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(packet(widget.id, Handler.Handler1, Update.Password,
        password: oldPassController.text.toString().trim(),
        misc: newPassController.text.toString().trim())));
    channel.stream.listen((event) {
      event = event.split(Header.Split)[1];
      event = jsonDecode(event);
      if(event["Header"] == Header.Success)
        {
          showSnackbar(context, "Password changed");
        }
      else if(event["Header"] == Header.Failed){
        if(event["Failure"] == Failure.Credentials){
          showSnackbar(context, "Invalid credentials");
        }
        else
          {
            showSnackbar(context, "Try after sometime");
          }
      }
    });
  }

  void showSnackbar(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          print('undo pressed');
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('View Profile');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => placeHolder(username: "temp")));

        setState(() {});
        break;
      case 1:
        showDialog(
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return AlertDialog(
                  title: Text('Change Password'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (newPassController.text !=
                            confirmPassController.text) {
                          showSnackbar(
                              context, "New and Confirm passwords don't match");
                        } else {
                          fetch();
                        }
                      },
                      child: Text('Change Password'),
                    ),
                  ],
                  scrollable: true,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: oldPassController,
                            decoration: InputDecoration(
                              labelText: 'Old Password',
                              icon: Icon(Icons.password_rounded),
                            ),
                          ),
                          TextFormField(
                            controller: newPassController,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              icon: Icon(Icons.fiber_new_rounded),
                            ),
                          ),
                          TextFormField(
                            controller: confirmPassController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              icon: Icon(Icons.new_label),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
            context: context);
        setState(() {});
        break;
      case 2:
        print('logout');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => placeHolder(username: "temp")));
        // Navigator.pop(context);
        break;
    }
  }

  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(
          Icons.account_circle_outlined,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            title: Text(widget.username),
            subtitle: Text(widget.curstatus.name),
            leading: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/${widget.username[0].toLowerCase()}.png'),
              radius: 30,
            ),
          ),
          value: 0,
        ),
        PopupMenuItem(
          child: Row(
            children: const [
              Icon(
                Icons.manage_accounts,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Manage account'),
            ],
          ),
          value: 1,
        ),
        const PopupMenuDivider(
          height: 5,
        ),
        PopupMenuItem(
          child: Row(
            children: const [
              Icon(
                Icons.logout,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Logout'),
            ],
          ),
          value: 2,
        ),
      ],
      onSelected: (item) {
        selectedItem(context, item);
      },
    );
  }
}
