import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:library_management/Constants.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

var username = TextEditingController();
var password = TextEditingController();

void login() {
  print(username.text);
  print(password.text);
}

class _MainState extends State<Main> {
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
              child: Card(
                shadowColor: const Color.fromARGB(255, 174, 230, 252),
                color: const Color.fromARGB(255, 200, 200, 200),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 5,
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
                                const InputDecoration(hintText: "Username"),
                            controller: username,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: password,
                            obscureText: true,
                            decoration:
                                const InputDecoration(hintText: "Password"),
                          ),
                        ),
                        const Center(
                          child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: login,
                                child: Text("Login"),
                              )),
                        )
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

AppBar appBar() {
  return AppBar(
    title: const Text("Library management system"),
    elevation: 0,
  );
}
