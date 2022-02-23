import 'dart:io';
import 'package:library_management/Constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String parser(List<String> data) {
  String temp = data.join(Header.Split);
  return temp.length.toString() + Header.Split + temp;
}

List<String> commands(String data) {
  List<String> tem =data.split(Header.Split);
  tem.removeAt(0);
  return tem;
}
Uri webSocket()
{
  return Uri.parse("ws:" + ip + ":"+WebPort.toString());
}