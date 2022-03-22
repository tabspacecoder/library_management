import 'package:flutter/material.dart';
import 'package:library_management/Constants.dart';
import 'package:library_management/opac/opac_main.dart';

class NavBar extends StatelessWidget {
  userStatus curStatus;
  String username;
  NavBar({required this.curStatus, required this.username});

  ListView userListView(context) {
    return ListView(
      // Remove padding
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('$username'),
          accountEmail: Text('$curStatus'),
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
          leading: Icon(Icons.person),
          title: Text('Friends'),
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
          accountName: Text('$username'),
          accountEmail: Text('$curStatus'),
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
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  var bookNameController = TextEditingController();
                  var authorController = TextEditingController();
                  var isbnController = TextEditingController();
                  var categoryController = TextEditingController();
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Add Book'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller :bookNameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                icon: Icon(Icons.drive_file_rename_outline),
                              ),
                            ),
                            TextFormField(
                              controller :isbnController,
                              decoration: InputDecoration(
                                labelText: 'ISBN',
                                icon: Icon(Icons.add),
                              ),
                            ),
                            TextFormField(
                              controller :authorController,
                              decoration: InputDecoration(
                                labelText: 'Author',
                                icon: Icon(Icons.account_box ),
                              ),
                            ),
                            TextFormField(
                              controller :categoryController,
                              decoration: InputDecoration(
                                labelText: 'Category',
                                icon: Icon(Icons.category),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                          child: Text("Submit"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  );
                });
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
      child: curStatus == userStatus.user
          ? userListView(context)
          : adminListView(context),
    );
  }
}
