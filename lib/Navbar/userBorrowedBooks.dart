import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Network.dart';

class UserBorrowedBooks extends StatefulWidget {
  const UserBorrowedBooks({Key? key}) : super(key: key);

  @override
  State<UserBorrowedBooks> createState() => _UserBorrowedBooksState();
}

class _UserBorrowedBooksState extends State<UserBorrowedBooks> {

  late List<OutstandingListData> data ;
  Future<List<BookRequestData>> fetch() async {
    String id;
    bool loaded=false;
    void update(String id,String Status)async{
      final channel = WebSocketChannel.connect(webSocket());
      channel.sink.add(parser(
          packet(id, Handler.Handler1, Update.BookRequest,misc: id,status: Status.toString())));
    }


    late List<OutstandingListData> data ;
    Future<String> GetState() async {
      final prefs = await SharedPreferences.getInstance();
      id = prefs.getString("Id")!;
      if(id!=null){
         loaded=true;
        setState(() {});
      }
      print(loaded);
      return id;
    }
    id= await GetState();
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(
        packet(id, Handler.Handler1, Fetch.BookRequest, range: [-1, 0])));
    channel.stream.listen((event) {
      event = event.split(Header.Split)[1];
      for (dynamic i in jsonDecode(event)["Data"]) {
        i = jsonDecode(i);
        // BookRequestData temp = BookRequestData(i["RequestID"].toString(), i["BookName"],
        //     i["Author"], i["RequestBy"], i["Status"]);
        // data.add(temp);
      }
      // setState(() {
      // });
      channel.sink.close();
      setState(() {

      });
    });
    return [];
  }
  @override
  void initState() {
    // GetState();
    data=[];
    fetch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Borrowed Books')),
      body: Container(
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                DateTime tempDate = DateFormat("dd/MM/yy").parse(data[index].DueDate);
                bool isDue = DateTime.now().isAfter(tempDate);
                return ListTile(
                  title: Text(data[index].ISBN),
                  leading: Text(data[index].BorrowID),
                  subtitle: Text(data[index].UserName),
                  trailing: Card(child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(data[index].DueDate,style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                    color: isDue?Colors.red:Colors.green,
                  ),
                  onTap: () {
                    if(isDue){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {

                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function())
                                  setState) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text(
                                      'Request ID : ${data[index].BorrowID}'),
                                  content: Column(
                                    children: [
                                      ElevatedButton(onPressed: (){}, child: Text('Pay Fine')),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(
                                              context),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                        child: Text(
                                            "Update Status"),
                                        onPressed: () {
                                          Navigator.pop(
                                              context);

                                        })
                                  ],
                                );
                              },
                            );
                          });
                    }


                  },
                );
              }))),

    );
  }
}
