import 'package:flutter/material.dart';
class adminPendingRequestsPage extends StatefulWidget {
  const adminPendingRequestsPage({Key? key}) : super(key: key);

  @override
  State<adminPendingRequestsPage> createState() => _adminPendingRequestsPageState();
}

class _adminPendingRequestsPageState extends State<adminPendingRequestsPage> {
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
                unselectedLabelColor: Colors.lightBlueAccent,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.lightBlueAccent),
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Tab(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Tab(
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
                  ),

                ]),
          ),
          body: TabBarView(children: [
              Container(child: Text('Books'),),Container(child: Text('Magazines'),)

          ]),
        ));
  }
}
