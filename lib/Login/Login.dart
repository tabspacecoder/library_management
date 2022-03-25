import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:library_management/Constants.dart';
import 'package:library_management/Network.dart';
import 'package:library_management/HomePage/Home.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

var username = TextEditingController();
var password = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/Login/bg.jpg"), fit: BoxFit.fitHeight)),
        height: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Container(
                width: 400,
                height: 250,
                alignment:Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(10, 10),
                          color: Colors.black,
                          blurRadius: 20)
                    ]),
                // decoration:BoxDecoration(
                //   borderRadius: BorderRadius.circular(6.0),
                //   color: Colors.grey.shade50,
                //   shape: BoxShape.rectangle,
                //   boxShadow: [
                //     BoxShadow(
                //         color: Colors.grey.shade300,
                //         spreadRadius: 0.0,
                //         blurRadius:10,
                //         offset: Offset(3.0, 3.0)),
                //     BoxShadow(
                //         color: Colors.grey.shade400,
                //         spreadRadius: 0.0,
                //         blurRadius: 10 / 2.0,
                //         offset: Offset(3.0, 3.0)),
                //     BoxShadow(
                //         color: Colors.white,
                //         spreadRadius: 2.0,
                //         blurRadius: 10,
                //         offset: Offset(-3.0, -3.0)),
                //     BoxShadow(
                //         color: Colors.white,
                //         spreadRadius: 2.0,
                //         blurRadius: 10 / 2,
                //         offset: Offset(-3.0, -3.0)),
                //   ],
                // ),
                // shadowColor: const Color.fromARGB(255, 174, 230, 252),
                // color: const Color.fromARGB(255, 220, 220, 220),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(25)),
                child: SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: "Username"),
                            controller: username,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: password,
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: "Password"),
                          ),
                        ),
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final channel =
                                      WebSocketChannel.connect(webSocket());
                                  var data = packet("",Handler.Handler1,Header.Login,username: username.text.toString(),password: sha512.convert(utf8.encode(password.text)).toString());
                                  channel.sink.add(parser(data));
                                  channel.stream.listen((event) async {
                                    event = event.split(Header.Split)[1];
                                    var out = jsonDecode(event);
                                    if (out["Header"] == Header.Success) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home(
                                                    id: out["Data"],
                                                    status: out['Misc'],
                                                    username: username.text
                                                        .toString(),
                                                  )));
                                    } else if (out["Header"] == Header.Failed) {
                                      _asyncConfirmDialog(context);
                                    }
                                    channel.sink.close();
                                  });
                                },
                                child: const Text("Login"),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

Future<void> _asyncConfirmDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invalid Credentials'),
        content: const Text('Check your username and password.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

AppBar appBar() {
  return AppBar(
    title: const Text("Library management system"),
    elevation: 0,
  );
}
