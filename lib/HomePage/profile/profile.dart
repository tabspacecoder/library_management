
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_management/HomePage/Home.dart';
import 'placeholderTemp.dart';


class PopUpProfileButton extends StatefulWidget {

  @override
  _PopUpProfileButtonState createState() => _PopUpProfileButtonState();
}

class _PopUpProfileButtonState extends State<PopUpProfileButton> {
  void selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('View Profile');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeHolder(username:"temp" )));

        setState(() {});
        break;
      case 1:
        print('Manage Profile');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeHolder(username:"temp" )));
        setState(() {});
        break;
      case 2:
        print('logout');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home(id: "temp", username: "Test",status: 1,)),
        );
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
            title: Text('test'),
            subtitle: Text('Test'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://amrita.edu/wp-content/uploads/2019/11/Mata-Amritanandamayi.png'),
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

