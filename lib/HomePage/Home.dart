import 'package:flutter/material.dart';
import 'package:library_management/HomePage/News/news.dart';
import 'package:library_management/HomePage/GlobalSearchBar.dart';
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
  late String curStatus;
  String username="";
  String id="";
  int status = 0;

  @override
  void initState() {
    super.initState();
    GetState();
  }

  void GetState() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString("Id")!;
    username=prefs.getString("Name")!;
    status = prefs.getInt("Status")!;
  }

  @override
  Widget build(BuildContext context) {

    if (status & Privileges.SuperAdmin == Privileges.SuperAdmin) {
      curStatus = UserStat.SuperAdmin;
    } else if (status & Privileges.Admin == Privileges.Admin) {
      curStatus = UserStat.Admin;
    } else {
      curStatus = UserStat.User;
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
                      image: AssetImage('assets/background.png'),
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
                Text('Libria '),
                // exampleTextField(),3
              ],
            ),
            // automaticallyImplyLeading: false,
            actions: [
              curStatus == UserStat.SuperAdmin
                  ? superAdminPopUpProfileButton(username: username, curstatus: curStatus,id: id,)
                  : curStatus == UserStat.Admin
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

