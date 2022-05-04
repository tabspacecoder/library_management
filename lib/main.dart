import 'package:flutter/material.dart';
import 'package:library_management/HomePage/Home.dart';
import 'package:library_management/Login/Login.dart';
import 'package:library_management/opac/opac_main.dart';
import 'HomePage/profile/Profile Window.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    routes: {
      '/Login':(context)=>const Login(),
      '/Home':(context)=>const Home(),
      '/Profile':(context)=>const ProfileWindow()
    },
    initialRoute: "/Login",
  ));
}




