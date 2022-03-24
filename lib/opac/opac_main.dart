

import 'package:flutter/material.dart';

class opacHome extends StatefulWidget {
  const opacHome({Key? key}) : super(key: key);

  @override
  State<opacHome> createState() => _opacHomeState();
}

class _opacHomeState extends State<opacHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('OPAC'),
      ),
      body: Container(),
    );
  }
}
