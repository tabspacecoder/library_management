import 'package:flutter/material.dart';
import 'package:library_management/Circulation/CirculationHomePage.dart';
import 'package:library_management/HomePage/Home.dart';
import 'package:library_management/HomePage/Magazines/MagazineRequestStatus.dart';
import 'package:library_management/HomePage/Magazines/MagazineRequests.dart';
import 'package:library_management/HomePage/profile/userRequests.dart';
import 'package:library_management/Login/Login.dart';
import 'HomePage/Books/BookRequestStatus.dart';
import 'HomePage/Books/BookRequests.dart';
import 'HomePage/profile/Profile Window.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    routes: {
      '/Login':(context)=>const Login(),
      '/Home':(context)=>const Home(),
      '/Profile':(context)=>const ProfileWindow(),
      '/MagazineRequests':(context)=>const MagazineRequests(),
      '/MagazineRequestStatus':(context)=>const MagazineRequestStatus(),
      '/BookRequest':(context)=>const BookRequests(),
      '/BookRequestStatus':(context)=>const BookRequestStatus(),
      '/Circulation':(context)=> circulationHomePage(),
      '/UserRequests':(context)=> userRequestsPage(),
    },
    initialRoute: "/Login",
  ));
}




