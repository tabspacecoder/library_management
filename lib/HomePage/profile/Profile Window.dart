import 'package:flutter/material.dart';

class ProfileWindow extends StatelessWidget {
  const ProfileWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = ModalRoute.of(context)?.settings.arguments as String;

    var controller1 = TextEditingController();
    controller1.text = username;
    return Scaffold(
      body:Center(
        child: Container(
          width: 600,
          child: Column(
            children: [Row(children: [const Text("Name: "),TextField(enabled: false,controller: controller1,)],)],
          ),
        ),
      ),
    );
  }
}
