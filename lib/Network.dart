import 'dart:io';
import 'package:library_management/Constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Network {
  late Socket sock;
  void init() async {
    sock = await Socket.connect(ip,port);
  }

  String parser(List<String> data) {
    return data.join(Header.Split);
  }

  String request(String data) {
    int length = data.length;
    sock.write(length.toString() + Header.Split + data);
    sock.listen((data) {});
    return "";
  }
}
