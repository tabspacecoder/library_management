import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:library_management/Constants.dart';
import 'package:library_management/Navbar/adminPendingRequests.dart';
import 'package:library_management/Network.dart';
import 'package:library_management/opac/opac_main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NavBar extends StatefulWidget {
  userStatus curStatus;
  String username;
  String id;

  NavBar({required this.curStatus, required this.username, required this.id});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late List<BookRequestData> data;
  void fetch() async {
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(packet(
        widget.id, Handler.Handler1, Fetch.BookRequest,
        range: [-1, 0])));
    channel.stream.listen((event) {
      event = event.split(Header.Split)[1];
      for (dynamic i in jsonDecode(event)["Data"]) {
        i = jsonDecode(i);
        BookRequestData temp = BookRequestData(i["RequestID"], i["BookName"],
            i["Author"], i["RequestBy"], i["Status"]);
        data.add(temp);
      }
      channel.sink.close();
      setState(() {});
    });
  }

  void addRequest(String UserName, String Author, String BookName) {
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(packet(widget.id, Handler.Handler1, Add.BookRequest,
        bookName: BookName, username: UserName, author: [Author])));
    channel.sink.close();
  }

  bool online_avail = false;
  bool offline_avail = false;
  String dropdownvalue = 'Offline';
  var items = [
    'Online',
    'Offline',
    'Both',
  ];
  late Uint8List pickedFileByteStream;
  late PlatformFile objFile;
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
              context,
              MaterialPageRoute(
                  builder: (context) => opacHome(
                        id: widget.id,
                        title: 'OPAC',
                      ))),
        ),
        // ListTile(
        //   leading: Icon(Icons.person),
        //   title: Text('Friends'),
        //   onTap: () => null,
        // ),
        // ListTile(
        //   leading: Icon(Icons.share),
        //   title: Text('Share'),
        //   onTap: () => null,
        // ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Create Book Request'),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  var bookNameController = TextEditingController();
                  var authorController = TextEditingController();
                  return StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text('Create new book request'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: bookNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    icon: Icon(Icons.drive_file_rename_outline),
                                  ),
                                ),
                                TextFormField(
                                  controller: authorController,
                                  decoration: InputDecoration(
                                    labelText: 'Author',
                                    icon: Icon(Icons.account_box),
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
                                print(widget.username);
                                addRequest(
                                    widget.username,
                                    authorController.text,
                                    bookNameController.text);
                                Navigator.pop(context);
                              })
                        ],
                      );
                    },
                  );
                });
          },
        ),
        ListTile(
          leading: Icon(Icons.remove_red_eye_outlined),
          title: Text('Search Book'),
          onTap: () => null,
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
              context,
              MaterialPageRoute(
                  builder: (context) => opacHome(
                        id: widget.id,
                        title: 'OPAC',
                      ))),
        ),
        ListTile(
          leading: Icon(Icons.all_out),
          title: Text('Book Circulation'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add new book'),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  var bookNameController = TextEditingController();
                  var authorController = TextEditingController();
                  var isbnController = TextEditingController();
                  var availController = TextEditingController();
                  return StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text('Add Book'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: bookNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    icon: Icon(Icons.drive_file_rename_outline),
                                  ),
                                ),
                                TextFormField(
                                  controller: isbnController,
                                  decoration: const InputDecoration(
                                    labelText: 'ISBN',
                                    icon: Icon(Icons.add),
                                  ),
                                ),
                                TextFormField(
                                  controller: authorController,
                                  decoration: const InputDecoration(
                                    labelText: 'Author',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                TextFormField(
                                  controller: availController,
                                  decoration: InputDecoration(
                                    labelText: 'Availablity',
                                    icon: Icon(Icons.category),
                                  ),
                                ),
                                // CheckboxListTile(
                                //   title: Text('Online : '),
                                //   value: online_avail,
                                //   onChanged: (value) {
                                //     setState(() {
                                //       online_avail = value!;
                                //     });
                                //     setState(() {});
                                //   },
                                // ),
                                // CheckboxListTile(
                                //   title: Text('Offline : '),
                                //   value: offline_avail,
                                //   onChanged: (value) {
                                //     setState(() {
                                //       print(1);
                                //       offline_avail = value!;
                                //     });},
                                // ),
                                DropdownButton(
                                  // Initial Value
                                  value: dropdownvalue,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  },
                                ),
                                dropdownvalue == 'Online' ||
                                        dropdownvalue == 'Both'
                                    ? ElevatedButton(
                                        child: Text('Upload Pdf'),
                                        onPressed: () async {
                                          var result = await FilePicker.platform
                                              .pickFiles(
                                            // type: FileType.values[':pdf'],
                                            withReadStream:
                                                true, // this will return PlatformFile object with read stream
                                          );
                                          if (result != null) {
                                            setState(() {
                                              objFile = result.files.single;
                                              pickedFileByteStream =
                                                  objFile.bytes!;
                                              String toRet =
                                                  pickedFileByteStream
                                                      .toString();
                                            });
                                          }
                                        })
                                    : SizedBox(),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Upload Thumbnail'))
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
                                if (dropdownvalue == 'Online' ||
                                    dropdownvalue == 'Both') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Upload the pdf!'),
                                          content: ElevatedButton(
                                              onPressed: () {},
                                              child: Text('Upload')),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Submit'),
                                            ),
                                          ],
                                        );
                                      });
                                }
                                Navigator.pop(context);
                              })
                        ],
                      );
                    },
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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => adminPendingRequestsPage(
                        id: widget.id,
                      ))),
          trailing: ClipOval(
            child: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: const Center(
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

  ListView superAdminListView(context) {
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
              context,
              MaterialPageRoute(
                  builder: (context) => opacHome(
                        id: widget.id,
                        title: 'OPAC',
                      ))),
        ),
        ListTile(
          leading: Icon(Icons.all_out),
          title: Text('Add User'),
          onTap: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  var usernameController = TextEditingController();
                  var passwordController = TextEditingController();
                  return StatefulBuilder(builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('Add User'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'User Name',
                                  icon: Icon(Icons.drive_file_rename_outline),
                                ),
                              ),
                              TextFormField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.password),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Create new user'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  });
                })
          },
        ),
        ListTile(
          leading: Icon(Icons.all_out),
          title: Text('Book Circulation'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add new book'),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  String toRet = "";
                  var bookNameController = TextEditingController();
                  var authorController = TextEditingController();
                  var isbnController = TextEditingController();
                  var availController = TextEditingController();
                  void fetch() async {
                    final channel = WebSocketChannel.connect(webSocket());

                    channel.sink.add(parser(packet(
                      widget.id,
                      Handler.Handler1,
                      Add.BookRecord,
                      bookName: bookNameController.text,
                      isbn: isbnController.text,
                      author: [authorController.text],
                      availability: int.parse(availController.text),
                      type: dropdownvalue == 'Online'
                          ? Avail.Online
                          : dropdownvalue == 'Offline'
                              ? Avail.Offline
                              : (Avail.Offline + Avail.Online),
                      book: toRet,
                    )));
                    channel.stream.listen((event) {
                      event = event.split(Header.Split)[1];
                      event = jsonDecode(event);
                      if (event["Header"] == Header.Success) {
                      } else if (event["Header"] == Header.Failed) {}
                    });
                  }

                  return StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return AlertDialog(
                        scrollable: true,
                        title: Text('Add Book'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: bookNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    icon: Icon(Icons.drive_file_rename_outline),
                                  ),
                                ),
                                TextFormField(
                                  controller: isbnController,
                                  decoration: const InputDecoration(
                                    labelText: 'ISBN',
                                    icon: Icon(Icons.add),
                                  ),
                                ),
                                TextFormField(
                                  controller: authorController,
                                  decoration: const InputDecoration(
                                    labelText: 'Author',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                TextFormField(
                                  controller: availController,
                                  decoration: const InputDecoration(
                                    labelText: 'Availablity',
                                    icon: Icon(Icons.category),
                                  ),
                                ),
                                // CheckboxListTile(
                                //   title: Text('Online : '),
                                //   value: online_avail,
                                //   onChanged: (value) {
                                //     setState(() {
                                //       online_avail = value!;
                                //     });
                                //     setState(() {});
                                //   },
                                // ),
                                // CheckboxListTile(
                                //   title: Text('Offline : '),
                                //   value: offline_avail,
                                //   onChanged: (value) {
                                //     setState(() {
                                //       print(1);
                                //       offline_avail = value!;
                                //     });},
                                // ),
                                DropdownButton(
                                  // Initial Value
                                  value: dropdownvalue,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  },
                                ),
                                dropdownvalue == 'Online' ||
                                        dropdownvalue == 'Both'
                                    ? ElevatedButton(
                                        child: Text('Upload Pdf'),
                                        onPressed: () async {
                                          var result = await FilePicker.platform
                                              .pickFiles(
                                            // type: FileType.values[':pdf'],
                                            withReadStream:
                                                true, // this will return PlatformFile object with read stream
                                          );
                                          if (result != null) {
                                            setState(() {
                                              objFile = result.files.single;
                                              pickedFileByteStream =
                                                  objFile.bytes!;
                                              toRet = pickedFileByteStream
                                                  .toString();
                                            });
                                          }
                                        })
                                    : ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Upload Thumbnail')),
                                SizedBox(
                                  height: 3,
                                ),
                                dropdownvalue == 'Online' ||
                                        dropdownvalue == 'Both'
                                    ? ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Upload Thumbnail'))
                                    : SizedBox()
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
                                fetch();

                                Navigator.pop(context);
                              })
                        ],
                      );
                    },
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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => adminPendingRequestsPage(
                        id: widget.id,
                      ))),
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
          : widget.curStatus == userStatus.superadmin
              ? superAdminListView(context)
              : adminListView(context),
    );
  }
}
