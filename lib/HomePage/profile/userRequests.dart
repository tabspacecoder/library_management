
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:library_management/Constants.dart';
import 'package:library_management/Network.dart';

class userRequestsPage extends StatefulWidget {
  String id,username;
  userRequestsPage({required this.id,required this.username});

  @override
  State<userRequestsPage> createState() =>
      _userRequestsPageState();
}

class _userRequestsPageState extends State<userRequestsPage> {
   List<BookRequestData> data = [];
  Future<List<BookRequestData>> fetch() async {
    final channel = WebSocketChannel.connect(webSocket());
    channel.sink.add(parser(
        packet(widget.id, Handler.Handler1, Fetch.BookRequestStatus, range: [-1, 0],username: widget.username)));
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
    return data;
  }
  @override
  void initState() {
    data=[];
    fetch();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Requests'),
            backgroundColor: Colors.blue,
            elevation: 0,
            bottom: TabBar(
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.lightBlueAccent),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.lightBlueAccent, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Books"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.lightBlueAccent, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Magazines"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            Container(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      List<String> items = [
                        'Processing',
                        'Approved',
                        'Declined'
                      ];
                      String dropdownvalue = items[0];
                      if (int.parse(data[index].Status) &
                      RequestStatus.processing ==
                          RequestStatus.processing) {
                        dropdownvalue = items[0];
                      } else if (int.parse(
                          data[index].Status) &
                      RequestStatus.approved ==
                          RequestStatus.approved) {
                        dropdownvalue = items[1];
                      } else if (int.parse(
                          data[index].Status) &
                      RequestStatus.declined ==
                          RequestStatus.declined) {
                        dropdownvalue = items[2];
                      } else {
                        dropdownvalue = items[0];
                      }
                      return ListTile(
                        title: Text(data[index].BookName),
                        subtitle: Text(data[index].Author),
                        trailing: Text(dropdownvalue),
                        onTap: () {
                        },
                      );
                    }))),
            // Container(
            //     child: FutureBuilder(
            //         future: fetch(),
            //         builder: (context, AsyncSnapshot snapshot) {
            //           if (!snapshot.hasData) {
            //             return Center(child: CircularProgressIndicator());
            //           } else {
            //             return Container(
            //                 child: ListView.builder(
            //                     itemCount: snapshot.data.length,
            //                     itemBuilder: ((context, index) {
            //                       List<String> items = [
            //                         'Processing',
            //                         'Approved',
            //                         'Declined'
            //                       ];
            //                       String dropdownvalue = items[0];
            //                       if (int.parse(snapshot.data[index].Status) &
            //                       RequestStatus.processing ==
            //                           RequestStatus.processing) {
            //                         dropdownvalue = items[0];
            //                       } else if (int.parse(
            //                           snapshot.data[index].Status) &
            //                       RequestStatus.approved ==
            //                           RequestStatus.approved) {
            //                         dropdownvalue = items[1];
            //                       } else if (int.parse(
            //                           snapshot.data[index].Status) &
            //                       RequestStatus.declined ==
            //                           RequestStatus.declined) {
            //                         dropdownvalue = items[2];
            //                       } else {
            //                         dropdownvalue = items[0];
            //                       }
            //                       return ListTile(
            //                         title: Text(snapshot.data[index].BookName),
            //                         subtitle: Text(snapshot.data[index].Author),
            //                         trailing:
            //                         Text(dropdownvalue),
            //                         onTap: () {
            //                         },
            //                       );
            //                     })));
            //           }
            //         })),
            Container(
              child: Text('Magazines'),
            )
          ]),
        ));
  }
}
