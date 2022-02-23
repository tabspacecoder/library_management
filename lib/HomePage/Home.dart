import 'package:flutter/material.dart';
import 'package:library_management/HomePage/News/news.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Home extends StatefulWidget {
  String id, username;
  Home({required this.id, required this.username});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            body: TabBarView(
              children: [Container(), news(id: widget.id)],
            ),
            appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: DropdownSearch(
                      dialogMaxWidth: 100.0,
                      dropdownSearchDecoration: const InputDecoration(
                        hintText: "Select a country",
                        labelText: "Menu mode *",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                      mode: Mode.MENU,
                    ),
                  )
                ],
                bottom: const TabBar(
                  tabs: [Icon(Icons.home), Icon(Icons.newspaper)],
                )),
          )),
    );
  }
}
