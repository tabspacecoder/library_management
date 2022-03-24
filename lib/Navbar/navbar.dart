import 'package:flutter/material.dart';
import 'package:library_management/Constants.dart';
import 'package:library_management/Navbar/addbook.dart';
import 'package:library_management/opac/opac_main.dart';

class NavBar extends StatefulWidget {
  userStatus curStatus;
  String username;

  NavBar({required this.curStatus, required this.username});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  bool online_avail=false;
  bool offline_avail=false;
  String dropdownvalue = 'Offline';
  var items = [
    'Online',
    'Offline',
    'Both',
  ];
  ListView userListView(context) {
    return ListView(
      // Remove padding
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('${widget.username}'),
          accountEmail: Text('${widget.curStatus}'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          leading: Icon(Icons.category),
          title: Text('OPAC'),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => opacHome())),
        ),
        ListTile(
          leading: Icon(Icons.new_label),
          title: Text('Request new book'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Share'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Request'),
          onTap: () => null,
          trailing: ClipOval(
            child: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: Center(
                child: Text(
                  '8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Policies'),
          onTap: () => null,
        ),
        Divider(),
        ListTile(
          title: Text('Exit'),
          leading: Icon(Icons.exit_to_app),
          onTap: () => null,
        ),
      ],
    );
  }

  ListView adminListView(context) {
    return ListView(
      // Remove padding
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('${widget.username}'),
          accountEmail: Text('${widget.curStatus}'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          leading: Icon(Icons.category),
          title: Text('OPAC'),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => opacHome())),
        ),
        ListTile(
          leading: Icon(Icons.all_out),
          title: Text('Book Circulation'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add new book'),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>addBookPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.remove_red_eye_outlined),
          title: Text('Search Book'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Pending Requests'),
          onTap: () => null,
          trailing: ClipOval(
            child: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: Center(
                child: Text(
                  '8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Policies'),
          onTap: () => null,
        ),
        Divider(),
        ListTile(
          title: Text('Exit'),
          leading: Icon(Icons.exit_to_app),
          onTap: () => null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: widget.curStatus == userStatus.user
          ? userListView(context)
          : adminListView(context),
    );
  }
}
