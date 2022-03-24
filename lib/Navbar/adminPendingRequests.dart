import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../Constants.dart';
import '../Network.dart';
class adminPendingRequestsPage extends StatefulWidget {
  String id;
  adminPendingRequestsPage({required this.id});


  @override
  State<adminPendingRequestsPage> createState() => _adminPendingRequestsPageState();
}

class _adminPendingRequestsPageState extends State<adminPendingRequestsPage> {


  // ListView pendingBooksList() async {
  //   final channel = WebSocketChannel.connect(webSocket());
  //   List<Widget> ret = [];
  //   List<BookRequestData> ret1 = [];
  //   channel.sink.add(parser(packet(widget.id, Handler.Handler1, Search.Books,BookRequDestData)));
  //   channel.stream.listen((event) {
  //     event = event.split(Header.Split)[1];
  //     for(dynamic i in jsonDecode(event)["Data"])
  //     {
  //       i = jsonDecode(i);
  //       BookData tmp = BookData(i["ISBN"],i["BookName"],i["Author"],i["Availability"],i["Type"],i["Thumbnail"]);
  //       ret1.add(tmp);
  //       ret.add(listItem(
  //           ontap: () {
  //             if(filteredSearchHistory.isNotEmpty)
  //             {
  //               addSearchTerm(filteredSearchValues.first);
  //               selectedTerm = filteredSearchValues.first.BookName;
  //               //controller.close();
  //             }
  //           },
  //           curBook: tmp
  //       ));
  //     }
  //     channel.sink.close();
  //     setState(() {});
  //   });
  //   return ListView.builder(
  //       itemCount: 5,
  //       itemBuilder: (BuildContext context,int index)
  //   {
  //     return ListTile(
  //         leading: Icon(Icons.list),
  //         trailing: Text("GFG",
  //           style: TextStyle(
  //               color: Colors.green, fontSize: 15),),
  //         title: Text("List item $index")
  //     );
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Pending Requests'),
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
                          border: Border.all(color: Colors.lightBlueAccent, width: 1)),
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
                          border: Border.all(color: Colors.lightBlueAccent, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Magazines"),
                      ),
                    ),
                  ),

                ]),
          ),
          body: TabBarView(children: [
              Container(child: Text('Books'),),Container(child: Text('Magazines'),)

          ]),
        ));
  }
}
