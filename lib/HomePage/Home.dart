
import 'package:flutter/material.dart';
import 'package:library_management/HomePage/News/news.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:library_management/Navbar/navbar.dart';
import 'profile/profile.dart';
import 'searchbar.dart';

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
            drawer: NavBar(),
            body: Stack(
              fit: StackFit.expand,
              children: [
                TabBarView(
                  children: [Container(), news(id: widget.id)],
                ),
                buildFloatingSearchBar(),
              ],
            ),
            // body: TabBarView(
            //   children: [Container(), news(id: widget.id)],
            // ),
            appBar: AppBar(
                title: Text('Library Management'),
                // automaticallyImplyLeading: false,
                actions: [
                  PopUpProfileButton(),
                ],
                bottom: TabBar(
                  tabs: [Icon(Icons.home), Icon(Icons.add)],
                )),
          )),
    );
  }
}
//    SizedBox(
//                     width: 200,
//                     height: 50,
//                     child: DropdownSearch(
//                       dialogMaxWidth: 100.0,
//                       dropdownSearchDecoration: const InputDecoration(
//                         hintText: "Select a country",
//                         labelText: "Menu mode *",
//                         contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
//                         border: OutlineInputBorder(),
//                       ),
//                       mode: Mode.MENU,
//                     ),
//                   )



// SizedBox(
// width: MediaQuery.of(context).size.width / 2,
// child: Container(
// child: TextField(
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.search),
// suffixIcon: IconButton(
// icon: Icon(Icons.clear),
// disabledColor: Colors.white,
// onPressed: () {
// /* Clear the search field */
// },
// ),
// hintText: 'Search...',
// border: InputBorder.none),
// ),
// ))