
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';


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

class adminPopUpProfileButton extends StatefulWidget {
  String username;
  String id;
  userStatus curstatus;
  adminPopUpProfileButton({required this.username,required this.curstatus,required this.id});

  @override
  _adminPopUpProfileButtonState createState() => _adminPopUpProfileButtonState();
}

class _adminPopUpProfileButtonState extends State<adminPopUpProfileButton> {

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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeHolder(username:"temp" )));

        setState(() {});
        break;
      case 1:
        print('Change Password');
        showDialog(builder: (BuildContext context) {
          var oldPassController = TextEditingController();
          var newPassController = TextEditingController();
          var confirmPassController = TextEditingController();
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
                  if(newPassController.text != confirmPassController.text){
                    showSnackbar(context, "New and Confirm passwords don't match");
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
        }) ; }, context: context);
        setState(() {});
        break;
      case 2:
        print('logout');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeHolder(username:"temp" )));
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
              backgroundColor: Colors.white,
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

