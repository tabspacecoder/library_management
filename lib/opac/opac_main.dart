

import 'package:flutter/material.dart';
import 'package:library_management/opac/pop_up_filter.dart';


class opacHome extends StatefulWidget {
  const opacHome({Key? key}) : super(key: key);

  @override
  _opacHomeState createState() => _opacHomeState();
}

class _opacHomeState extends State<opacHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            bottom: AppBar(
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search for something',
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.blue,
                          onPressed: () {

                          },
                        ),
                        suffixIcon: popUpFilterButton()),
                  ),
                ),
              ),
            ),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 400,
                child: Center(
                  child: Text(
                    'This is an awesome shopping platform',
                  ),
                ),
              ),
              Container(
                height: 1000,
                color: Colors.white,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}