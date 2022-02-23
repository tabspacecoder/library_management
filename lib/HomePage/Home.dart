import 'package:flutter/material.dart';
import 'package:library_management/HomePage/News/news.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

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
          initialIndex: 1,
          child: Scaffold(
            body: TabBarView(
              children: [Container(),news(id: widget.id)],
            ),
            appBar: AppBar(
                automaticallyImplyLeading: false,
                bottom: const TabBar(
                  tabs: [Icon(Icons.home), Icon(Icons.newspaper)],
                )),
          )),
    );
  }
}
