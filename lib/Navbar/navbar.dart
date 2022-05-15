import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:library_management/Constants.dart';
import 'package:library_management/Navbar/adminPendingRequests.dart';
import 'package:library_management/Network.dart';
import 'package:library_management/opac/opac_main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NavBar extends StatefulWidget {
  String curStatus;
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

  void changePasswordAPI(
      dynamic oldPassController, dynamic newPassController) async {
    final channel = WebSocketChannel.connect(webSocket());

    channel.sink.add(parser(packet(widget.id, Handler.Handler1, Update.Password,
        password: sha512
            .convert(utf8.encode(oldPassController.text.toString().trim()))
            .toString(),
        misc: sha512
            .convert(utf8.encode(newPassController.text.toString().trim()))
            .toString())));
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

  void addBookRequest(String UserName, String Author, String BookName) {
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(packet(widget.id, Handler.Handler1, Add.BookRequest,
        bookName: BookName, username: UserName, author: [Author])));
    channel.stream.listen((event) {});
    channel.sink.close();
  }

  void addMagazineRequest(String UserName, String Author, String BookName) {
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(packet(
        widget.id, Handler.Handler1, Add.MagazineSubscriptionRequest,
        bookName: BookName, username: UserName, author: [Author])));
    channel.stream.listen((event) {});
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
  String DueDate = '';
  void selectedItemCirculation(BuildContext context, int item) {
    switch (item) {
      case 1:
        print('View Profile');
        setState(() {});
        break;
      case 0:
        showDialog(
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return AlertDialog(
                  title: Text('New Book Borrowal'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // DueDate = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                        print('Book Name - ${BookNameController.text}');
                        print('Username - ${UsernameController.text}');
                        print('Issue Date - $IssueDate');
                        // print('Due date - $DueDate');
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add record'),
                    ),
                  ],
                  scrollable: true,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: BookNameController,
                            decoration: const InputDecoration(
                              labelText: 'Enter Book name',
                              icon: Icon(Icons.book),
                            ),
                          ),
                          TextFormField(
                            controller: UsernameController,
                            decoration: const InputDecoration(
                              labelText: 'Enter username',
                              icon: Icon(Icons.account_circle),
                            ),
                          ),
                          // ListTile(
                          //   title: Text('Due Date'),
                          //   subtitle: Text(
                          //       '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                          //   leading: IconButton(
                          //     icon: Icon(Icons.calendar_today),
                          //     onPressed: () {
                          //       _selectDate(context);
                          //     },
                          //   ),
                          // ),
                          // TextFormField(
                          //   controller: DueDateController,
                          //   decoration: InputDecoration(
                          //     labelText: 'Due Date',
                          //     icon: IconButton(icon:Icon(Icons.calendar_today), onPressed: () {_selectDate(context);},),
                          //   ),
                          // ),
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

        break;

      case 3:
        print('My requests');
        break;
    }
  }

  var UsernameController = TextEditingController();
  var BookNameController = TextEditingController();
  var DueDateController = TextEditingController();
  String IssueDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
    setState(() {});
  }

  late Uint8List pickedFileByteStream;
  late Uint8List pickedFileByteStreamTn;
  late PlatformFile objFile;
  late PlatformFile objFileTn;
  ListView userListView(context) {
    return ListView(
      // Remove padding
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(widget.username),
          accountEmail: Text(widget.curStatus),
          currentAccountPicture:  CircleAvatar(
            backgroundImage: AssetImage('assets/${widget.username[0].toLowerCase()}.png'),
            // backgroundImage: AssetImage('assets/a.png'),
            radius: 30,
          ),
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
            leading: const Icon(Icons.book),
            title: const Text("My magazines"),
            onTap: () {
              Navigator.pushNamed(context, '/MyMagazine');
            }),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Request Book'),
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
                        title: const Text('Create new book request'),
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
                                  controller: authorController,
                                  decoration: const InputDecoration(
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
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                              child: const Text("Submit"),
                              onPressed: () {
                                addBookRequest(
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
          leading: const Icon(Icons.add),
          title: const Text('Request Magazine'),
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
                        title: const Text('Create new magazine request'),
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
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                              child: const Text("Submit"),
                              onPressed: () {
                                addMagazineRequest(
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
        const Divider(),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text("Book Request status"),
          onTap: () {
            Navigator.pushNamed(context, '/BookRequestStatus');
          },
        ),
        ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Magazine Request status"),
            onTap: () {
              Navigator.pushNamed(context, "/MagazineRequestStatus");
            }),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text("Change Password"),
          onTap: () {
            showDialog(
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    var oldPassController = TextEditingController();
                    var newPassController = TextEditingController();
                    var confirmPassController = TextEditingController();
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
                            if (newPassController.text !=
                                confirmPassController.text) {
                              showSnackbar(context,
                                  "New and Confirm passwords don't match");
                            } else {
                              changePasswordAPI(
                                  oldPassController, newPassController);
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
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Old Password',
                                  icon: Icon(Icons.password_rounded),
                                ),
                              ),
                              TextFormField(
                                controller: newPassController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  icon: Icon(Icons.fiber_new_rounded),
                                ),
                              ),
                              TextFormField(
                                controller: confirmPassController,
                                obscureText: true,
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
                  });
                },
                context: context);
            setState(() {});
          },
        ),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("Name");
              await prefs.remove("Id");
              await prefs.remove("Status");
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            }),
      ],
    );
  }

  ListView adminListView(context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(widget.username),
          accountEmail: Text(widget.curStatus),
          currentAccountPicture: CircleAvatar(
            backgroundImage:
                AssetImage('assets/${widget.username[0].toLowerCase()}.png'),
            // backgroundImage: AssetImage('assets/a.png'),
            radius: 30,
          ),
          decoration: const BoxDecoration(
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
                        title: 'Search Book',
                      ))),
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Pending Book Requests'),
          onTap: () => Navigator.pushNamed(context, '/PendingBookRequests'),
        ),
        ListTile(
          leading: Icon(Icons.library_books),
          title: Text('Pending Magazine Requests'),
          onTap: () => Navigator.pushNamed(context, '/PendingMagazineRequests'),
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
                                    ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
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
                                          }),
                                    )
                                    : SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        var result = await FilePicker.platform
                                            .pickFiles(
                                          // type: FileType.values[':pdf'],
                                          withReadStream:
                                          true, // this will return PlatformFile object with read stream
                                        );
                                        if (result != null) {
                                          setState(() {
                                            objFileTn = result.files.single;
                                            pickedFileByteStreamTn =
                                            objFileTn.bytes!;
                                            String toRet =
                                            pickedFileByteStreamTn
                                                .toString();
                                          });
                                        }
                                      },
                                      child: Text('Upload Thumbnail')),
                                )
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

        // ListTile(
        //   leading: Icon(Icons.notifications),
        //   title: Text('Pending Requests'),
        //   onTap: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => adminPendingRequestsPage(
        //                 id: widget.id,
        //               ))),
        //   trailing: ClipOval(
        //     child: Container(
        //       color: Colors.red,
        //       width: 20,
        //       height: 20,
        //       child: const Center(
        //         child: Text(
        //           '8',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 12,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        PopupMenuButton<int>(
          child: ListTile(
            leading: Icon(Icons.all_out),
            title: Text('Book Circulation'),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('New Book Borrowal'),
                  leading: CircleAvatar(
                    child: Icon(Icons.add),
                    radius: 30,
                  ),
                ),
              ),
              value: 0,
            ),
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Outstanding Books'),
                  leading: CircleAvatar(
                    child: Icon(Icons.outbond),
                    radius: 30,
                  ),
                ),
              ),
              value: 1,
            ),
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Post due!'),
                  leading: CircleAvatar(
                    child: Icon(Icons.warning),
                    radius: 30,
                  ),
                ),
              ),
              value: 2,
            ),
          ],
          onSelected: (item) {
            selectedItemCirculation(context, item);
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text("Change Password"),
          onTap: () {
            showDialog(
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    var oldPassController = TextEditingController();
                    var newPassController = TextEditingController();
                    var confirmPassController = TextEditingController();
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
                            if (newPassController.text !=
                                confirmPassController.text) {
                              showSnackbar(context,
                                  "New and Confirm passwords don't match");
                            } else {
                              changePasswordAPI(
                                  oldPassController, newPassController);
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
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Old Password',
                                  icon: Icon(Icons.password_rounded),
                                ),
                              ),
                              TextFormField(
                                controller: newPassController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  icon: Icon(Icons.fiber_new_rounded),
                                ),
                              ),
                              TextFormField(
                                controller: confirmPassController,
                                obscureText: true,
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
                  });
                },
                context: context);
            setState(() {});
          },
        ),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("Name");
              await prefs.remove("Id");
              await prefs.remove("Status");
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            }),
      ],
    );
  }

  ListView superAdminListView(context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(widget.username),
          accountEmail: Text(widget.curStatus),
          currentAccountPicture: CircleAvatar(
            backgroundImage:
            AssetImage('assets/${widget.username[0].toLowerCase()}.png'),
            // backgroundImage: AssetImage('assets/a.png'),
            radius: 30,
          ),
          decoration: const BoxDecoration(
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
                    title: 'Search Book',
                  ))),
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Pending Book Requests'),
          onTap: () => Navigator.pushNamed(context, '/PendingBookRequests'),
        ),
        ListTile(
          leading: Icon(Icons.library_books),
          title: Text('Pending Magazine Requests'),
          onTap: () => Navigator.pushNamed(context, '/PendingMagazineRequests'),
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
          leading: Icon(Icons.account_circle),
          title: Text('Add User'),
          onTap: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  String userPrevilege = 'User';
                  // List<DropdownMenuItem> items = [DropdownMenuItem(child: Text('User')),DropdownMenuItem(child: Text('Admin'))];
                  var items = [
                    'User',
                    'Admin',
                  ];
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                  // Initial Value
                                  value: userPrevilege,
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
                                      userPrevilege = newValue!;
                                    });
                                  },
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
                            if(userPrevilege == 'Admin'){
                              print(Privileges.Admin);
                            }
                            else{
                              print(Privileges.User);
                            }
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
        // ListTile(
        //   leading: Icon(Icons.notifications),
        //   title: Text('Pending Requests'),
        //   onTap: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => adminPendingRequestsPage(
        //             id: widget.id,
        //           ))),
        //   trailing: ClipOval(
        //     child: Container(
        //       color: Colors.red,
        //       width: 20,
        //       height: 20,
        //       child: const Center(
        //         child: Text(
        //           '8',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 12,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        PopupMenuButton<int>(
          child: ListTile(
            leading: Icon(Icons.all_out),
            title: Text('Book Circulation'),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('New Book Borrowal'),
                  leading: CircleAvatar(
                    child: Icon(Icons.add),
                    radius: 30,
                  ),
                ),
              ),
              value: 0,
            ),
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Outstanding Books'),
                  leading: CircleAvatar(
                    child: Icon(Icons.outbond),
                    radius: 30,
                  ),
                ),
              ),
              value: 1,
            ),
            PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Post due!'),
                  leading: CircleAvatar(
                    child: Icon(Icons.warning),
                    radius: 30,
                  ),
                ),
              ),
              value: 2,
            ),
          ],
          onSelected: (item) {
            selectedItemCirculation(context, item);
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text("Change Password"),
          onTap: () {
            showDialog(
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    var oldPassController = TextEditingController();
                    var newPassController = TextEditingController();
                    var confirmPassController = TextEditingController();
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
                            if (newPassController.text !=
                                confirmPassController.text) {
                              showSnackbar(context,
                                  "New and Confirm passwords don't match");
                            } else {
                              changePasswordAPI(
                                  oldPassController, newPassController);
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
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Old Password',
                                  icon: Icon(Icons.password_rounded),
                                ),
                              ),
                              TextFormField(
                                controller: newPassController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  icon: Icon(Icons.fiber_new_rounded),
                                ),
                              ),
                              TextFormField(
                                controller: confirmPassController,
                                obscureText: true,
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
                  });
                },
                context: context);
            setState(() {});
          },
        ),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("Name");
              await prefs.remove("Id");
              await prefs.remove("Status");
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: widget.curStatus == UserStat.User
          ? userListView(context)
          : widget.curStatus == UserStat.SuperAdmin
              ? superAdminListView(context)
              : adminListView(context),
    );
  }
}
