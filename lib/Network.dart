import 'dart:convert';
import 'dart:io';
import 'package:library_management/Constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String parser(String data) {
  return data.length.toString() + Header.Split + data;
}

String packet(String id, String handler, String header,
    {String username = "",
    String password = "",
    int permission = 0,
    String isbn = "",
    String bookName = "",
    List<String> author = const [],
    int type = 0,
    int availability = 0,
    String thumbnail = "",
    List<String> searchFilter = const [],
    String category = "",
    String book = "",
    int count = 0,
    String misc = "",
    String sort = "ASC",
    String status = "",
    List<int> range = const [],
    String email = "",
    String volume = "",
    String issue = ""}) {
  var data = {
    "ID": id,
    "Handler": handler,
    "Header": header,
    "UserName": username,
    "Password": password,
    "Permission": permission,
    "ISBN": isbn,
    "BookName": bookName,
    "Author": author,
    "Type": type,
    "Availability": availability,
    "Thumbnail": thumbnail,
    "SearchFilter": searchFilter,
    "Category": category,
    "Book": book,
    "Count": count,
    "Misc": misc,
    "Sort": sort,
    "Range": range,
    "Status": status,
    "Email": email,
    "Volume": volume,
    "Issue": issue
  };

  return jsonEncode(data);
}

Uri webSocket() {
  return Uri.parse("ws:" + ip + ":" + WebPort.toString());
}

