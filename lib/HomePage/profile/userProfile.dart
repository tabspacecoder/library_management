import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:library_management/HomePage/profile/userRequests.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../Constants.dart';
import '../../Network.dart';


class userPopUpProfileButton extends StatefulWidget {
  String username;
  String id;
  userStatus curstatus;
  userPopUpProfileButton({required this.username,required this.curstatus,required this.id});
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
        password: sha512.convert(utf8.encode(oldPassController.text.toString().trim())).toString(),
        misc: sha512.convert(utf8.encode(newPassController.text.toString().trim())).toString())));
    channel.stream.listen((event) {
      event = event.split(Header.Split)[1];
      event = jsonDecode(event);
      if (event["Header"] == Header.Success) {
        showSnackbar(context, "Password changed");
      } else if (event["Header"] == Header.Failed) {
        if (event["Failure"] == Failure.Credentials) {
          showSnackbar(context, "Invalid credentials");
        } else {
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
        Navigator.pushNamed(context, "/Profile",arguments: widget.username);
        setState(() {});
        break;
      case 1:
        showDialog(builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context,
              void Function(void Function()) setState) {
            return AlertDialog(
              title: const Text('Change Password'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if(newPassController.text != confirmPassController.text){
                      showSnackbar(context, "New and Confirm passwords don't match");
                    }
                    else{
                      fetch();
                    }
                  },
                  child: const Text('Change Password'),
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
                        decoration: const InputDecoration(
                          labelText: 'Old Password',
                          icon: Icon(Icons.password_rounded),
                        ),
                      ),
                      TextFormField(
                        controller: newPassController,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          icon: Icon(Icons.fiber_new_rounded),
                        ),
                      ),
                      TextFormField(
                        controller: confirmPassController,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          icon: Icon(Icons.new_label),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            );
          }) ; }, context: context);
        setState(() {});
        break;
      case 2:
        print('logout');
        Navigator.pushNamed(context, "/Profile",arguments: widget.username);
        break;

      case 3:
        print('My requests');
        Navigator.push(context, MaterialPageRoute(builder: (context)=>userRequestsPage(id: widget.id,username: widget.username,)));
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
              backgroundImage: AssetImage('assets/${widget.username[0].toLowerCase()}.png'),
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
              Text('Change Password'),
            ],
          ),
          value: 1,
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
              Text('My requests'),
            ],
          ),
          value: 3,
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

