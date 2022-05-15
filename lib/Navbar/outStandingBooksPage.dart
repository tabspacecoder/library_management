import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:library_management/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Network.dart';

class OutStandingRequests extends StatefulWidget {
  const OutStandingRequests({Key? key}) : super(key: key);

  @override
  State<OutStandingRequests> createState() => _OutStandingRequestsState();
}

class _OutStandingRequestsState extends State<OutStandingRequests> {


  Future<List<BookRequestData>> fetch() async {
    String id;

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

    print(data);
    return [];
  }

  @override
  void initState() {
    // GetState();
    data=[];
    fetch();
    super.initState();
  }
  void update(String id,String Status)async{
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(
        packet(id, Handler.Handler1, Update.BookRequest,misc: id,status: Status.toString())));
  }


  late List<OutstandingListData> data ;
  bool loaded=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outstanding requests'),
      ),
      body:  Container(
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(data[index].ISBN),
                  leading: Text(data[index].BorrowID),
                  subtitle: Text(data[index].UserName),
                  trailing: Text(data[index].DueDate),
                  onTap: () {
                    List<String> items = [
                      'NotReturned',
                      'Returned',
                    ];
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String dropdownvalue = items[0];
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
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(
                                          8.0),
                                      child: DropdownButton(
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownvalue =
                                                value.toString();
                                          });
                                        },
                                        items: items
                                            .map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        value: dropdownvalue,
                                      ),
                                    ),
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

                                          //add comments text field here

                                          String DueDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                                          dropdownvalue == items[0] ? data[index].ReturnDate = DueDate:data[index].ReturnDate='';

                                          update(data[index].BorrowID, data[index].ReturnDate);
                                          Navigator.pop(
                                              context);

                                      })
                                ],
                              );
                            },
                          );
                        });
                  },
                );
              }))),
    );
  }
}
