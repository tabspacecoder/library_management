import 'package:flutter/material.dart';
import 'package:library_management/Constants.dart';

class circulationHomePage extends StatefulWidget {
  const circulationHomePage({Key? key}) : super(key: key);

  @override
  State<circulationHomePage> createState() => _circulationHomePageState();
}

class _circulationHomePageState extends State<circulationHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circulation Control'),
      ),
      body: Container(
        child: Column(

        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  String title;
  CustomCard({required this.title,});


  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [Title(color: Colors.black, child: Text(widget.title))],
      ),
    );
  }
}
