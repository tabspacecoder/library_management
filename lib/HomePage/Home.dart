import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:library_management/HomePage/CommonSearch.dart';
import 'package:library_management/HomePage/News/news.dart';
import 'package:library_management/Navbar/navbar.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'profile/profile.dart';
import 'searchbar.dart';
import 'package:library_management/Constants.dart';
class Home extends StatefulWidget {
  String id, username;
  int status;
  Home({required this.id, required this.username,required this.status});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late userStatus curStatus;
  @override
  void initState() {
    super.initState();
    if(widget.status & Privileges.SuperAdmin == Privileges.SuperAdmin){
      curStatus = userStatus.superadmin;
    }
    else if(widget.status & Privileges.Admin == Privileges.Admin){
      curStatus = userStatus.admin;
    }
    else{
      curStatus=userStatus.user;
    }
    print(curStatus);
  }
  final autoSuggestBox = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            drawer: NavBar(curStatus: curStatus, username: widget.username,),
            body: Stack(
              fit: StackFit.expand,
              children: [
                TabBarView(
                  children: [Container(), news(id: widget.id)],
                ),
              ],
            ),
            // body: TabBarView(
            //   children: [Container(), news(id: widget.id)],
            // ),
            appBar: AppBar(
              title: const Text('Library Management'),
              // automaticallyImplyLeading: false,
              actions: [
                PopUpProfileButton(),
              ],
              bottom: const TabBar(
                tabs: [Icon(Icons.home), Icon(Icons.add)],
              ),
            ),
            floatingActionButton: Center(child: SizedBox(width:500,child: SearchBar(widget.id))),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
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


// AutoSuggestBox<String>(
// controller: autoSuggestBox,
// items: [
// 'Blue',
// 'Green',
// 'Red',
// 'Yellow',
// 'Grey',
// ],
// onSelected: (text) {
// print(text);
// },
// textBoxBuilder: (context, controller, focusNode, key) {
// const BorderSide _kDefaultRoundedBorderSide = BorderSide(
// style: BorderStyle.solid,
// width: 0.8,
// );
// return fluent.TextBox(
// key: key,
// controller: controller,
// focusNode: focusNode,
// suffixMode: fluent.OverlayVisibilityMode.editing,
// suffix: IconButton(
// icon: Icon(fluent.FluentIcons.close_pane),
// onPressed: () {
// controller.clear();
// focusNode.unfocus();
// },
// ),
// placeholder: 'Type a color',
// decoration: BoxDecoration(
// border: Border(
// top: _kDefaultRoundedBorderSide,
// bottom: _kDefaultRoundedBorderSide,
// left: _kDefaultRoundedBorderSide,
// right: _kDefaultRoundedBorderSide,
// ),
// borderRadius: focusNode.hasFocus
// ? BorderRadius.vertical(top: Radius.circular(3.0))
//     : BorderRadius.all(Radius.circular(3.0)),
// ),
// );
// },
// )