import 'package:flutter/material.dart';
import 'package:library_management/HomePage/News/news.dart';
import 'package:library_management/HomePage/GlobalSearchBar.dart';
import 'package:library_management/HomePage/Parameters.dart';
import 'package:library_management/HomePage/profile/superAdminProfile.dart';
import 'package:library_management/HomePage/profile/userProfile.dart';
import 'package:library_management/Navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile/adminProfile.dart';
import 'package:library_management/Constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late userStatus curStatus;
  String username="";
  String id="";
  int status = 0;
  static var data;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    void GetState() async {
      final prefs = await SharedPreferences.getInstance();
      id = prefs.getString("Name")!;
      username=prefs.getString("Id")!;
      status = prefs.getInt("Status")!;
    }
    GetState();
    if (status & Privileges.SuperAdmin == Privileges.SuperAdmin) {
      curStatus = userStatus.superadmin;
    } else if (status & Privileges.Admin == Privileges.Admin) {
      curStatus = userStatus.admin;
    } else {
      curStatus = userStatus.user;
    }
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          drawer: NavBar(
            id: id,
            curStatus: curStatus,
            username: username,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              TabBarView(
                children: [Container(
                  decoration: const BoxDecoration(

                    image:DecorationImage(
                      image: AssetImage('assets/homepage.png'),
                      fit: BoxFit.cover
                    ),
                  ),
                  child:Container() ,), news(id: id)],
              ),
            ],
          ),
          // body: TabBarView(
          //   children: [Container(), news(id: id)],
          // ),
          appBar: AppBar(
            title: Row(
              children: const [
                Text('Library Management'),
                // exampleTextField(),3
              ],
            ),
            // automaticallyImplyLeading: false,
            actions: [
              curStatus == userStatus.superadmin
                  ? superAdminPopUpProfileButton(username: username, curstatus: curStatus,id: id,)
                  : curStatus == userStatus.admin
                      ? adminPopUpProfileButton(username: username, curstatus: curStatus,id: id,)
                      : userPopUpProfileButton(username: username, curstatus: curStatus,id: id,),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home_filled), text: "Home"),
                Tab(
                    icon: Icon(
                      Icons.feed_outlined,
                    ),
                    text: "News")
              ],
            ),
          ),
          floatingActionButton: Center(
              child: SizedBox(width: 500, child: SearchBar(id))),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
        ));
  }
}

