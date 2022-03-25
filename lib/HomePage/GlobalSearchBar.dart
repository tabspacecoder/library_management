import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:library_management/Constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:library_management/Network.dart';

class SearchBar extends StatefulWidget {
  String id;

  SearchBar(this.id);
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<dynamic> ret1 = [];

  bool bookNameCheckbox = true;
  bool bookAuthorCheckbox = false;
  bool bookISBNCheckbox = false;
  bool magAuthorCheckbox = false;
  bool magNameCheckbox = false;
  String dropdownvalue = 'Books';
  String dropdownvaluefilter = 'ASC';
  var items = [
    'Books',
    'Magazines',
  ];
  var filteritems=[
    'ASC','DESC'
  ];

  Future<List<dynamic>> fetch(String name) async {
    final channel = WebSocketChannel.connect(webSocket());
    List<String> Params = [];
    String ISBN = "";
    String Author = "";
    print("------");
    print(bookAuthorCheckbox);
    print(bookISBNCheckbox);
    print(bookNameCheckbox);
    print("------");
    if(dropdownvalue == "Books"){
      if(bookAuthorCheckbox){
        Params.add(BookParams.Author);
        Author = name;
      }
      if(bookISBNCheckbox){
        Params.add(BookParams.ISBN);
        ISBN = name;
      }
      if(bookNameCheckbox){
        Params.add(BookParams.Name);
      }
      channel.sink.add(parser(packet(widget.id, Handler.Handler1, Search.Books,
          bookName: name,
          isbn: ISBN,
          author: [Author],
          searchFilter: Params,
          count: 10,
          sort: dropdownvaluefilter)));
      channel.stream.listen((event) {
        ret1 = [];
        event = event.split(Header.Split)[1];
        for (dynamic i in jsonDecode(event)["Data"]) {
          i = jsonDecode(i);
          BookData tmp = BookData(i["ISBN"], i["BookName"], i["Author"],
              i["Availability"], i["Type"], i["Thumbnail"]);
          ret1.add(tmp);
        }

        channel.sink.close();
      });
    }
    else{
      if(bookAuthorCheckbox){
        Params.add(MagazineParams.Author);
        Author = name;
      }
      if(bookNameCheckbox){
        Params.add(MagazineParams.Name);
      }
      channel.sink.add(parser(packet(widget.id, Handler.Handler1, Search.Magazines,
          bookName: name,
          searchFilter: Params,
          author: [Author],
          count: 10,
          sort: dropdownvaluefilter)));
      channel.stream.listen((event) {
        ret1 = [];
        event = event.split(Header.Split)[1];
        for (dynamic i in jsonDecode(event)["Data"]) {
          i = jsonDecode(i);
          MagazineData tmp = MagazineData(i["Name"], i["Volume"], i["Issue"],
              i["ReleaseDate"], i["Location"]);
          ret1.add(tmp);
        }

        channel.sink.close();
      });
    }


    return ret1;
  }

  Widget Popup(){
    return PopupMenuButton<int>(
        child: const Padding(

          padding: EdgeInsets.only(right: 4),
          child: Icon(
            Icons.filter_alt,
          ),
        ),
        itemBuilder: (context) =>  [
          PopupMenuItem(
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) { return Column(
                children: [
                  Row(
                    children:  [
                      const Icon(
                        Icons.library_books,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Type'),

                      const SizedBox(
                        width: 75,
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.article_outlined,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Order'),
                      const SizedBox(
                        width: 85,
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownvaluefilter,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: filteritems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvaluefilter = newValue!;
                          });
                        },
                      )
                    ],
                  ),
                  dropdownvalue == 'Books'?Row(
                    children:  [
                      const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Author'),
                      const SizedBox(
                        width: 75,
                      ),
                      Checkbox(
                        value: bookAuthorCheckbox,
                        onChanged: (bool? value) {
                          setState(() {
                            bookAuthorCheckbox = value!;
                          });
                        },
                      ),
                    ],
                  ):Row(
                    children:  [
                      const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Author'),
                      const SizedBox(
                        width: 75,
                      ),
                      Checkbox(
                        value: magAuthorCheckbox,
                        onChanged: (bool? value) {
                          setState(() {
                            magAuthorCheckbox = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  dropdownvalue == 'Books'?Row(
                    children:  [
                      const Icon(
                        Icons.assignment_outlined,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Title'),
                      const SizedBox(
                        width: 89,
                      ),
                      Checkbox(
                        value: bookNameCheckbox,
                        onChanged: (bool? value) {
                          setState(() {
                            bookNameCheckbox = value!;
                          });
                        },
                      ),

                    ],
                  ):Row(
                    children:  [
                      const Icon(
                        Icons.assignment_outlined,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Title'),
                      const SizedBox(
                        width: 89,
                      ),
                      Checkbox(
                        value: magNameCheckbox,
                        onChanged: (bool? value) {
                          setState(() {
                            magNameCheckbox = value!;
                          });
                        },
                      ),

                    ],
                  ),
                  dropdownvalue == 'Books'?Row(
                    children: [
                      const Icon(
                        Icons.article_outlined,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('ISBN'),
                      const SizedBox(
                        width: 85,
                      ),
                      Checkbox(
                        value: bookISBNCheckbox,
                        onChanged: (bool? value) {
                          setState(() {
                            const Icon(
                              Icons.assignment_outlined,
                              color: Colors.blue,
                            );
                            bookISBNCheckbox = value!;
                          });
                        },
                      ),
                    ],
                  ):const SizedBox(),
                ],
              ); },
            ),
            value: 1,
          ),
        ]
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10.0,
          ),
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                  focusColor: Colors.white70,
                  fillColor: Colors.white70,
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Popup(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: 'Search.....'),
            ),
            suggestionsCallback: (pattern) async {
              return await fetch(pattern);
            },
            itemBuilder: (context, dynamic suggestion) {
              return BookListTile(ontap: () {}, curBook: suggestion);
            },
            onSuggestionSelected: (dynamic suggestion) {
              print(suggestion);
              // Navigator.of(context).push<void>(MaterialPageRoute(
              //     builder: (context) => ProductPage(product: suggestion)));
            },
          ),
        ],
      ),
    );
  }
}

class BookListTile extends StatefulWidget {
  Function ontap;
  BookData curBook;
  BookListTile({required this.ontap, required this.curBook});

  @override
  _BookListTileState createState() => _BookListTileState();
}

class _BookListTileState extends State<BookListTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.curBook.Type & Avail.Online != 0 &&
        widget.curBook.Type & Avail.Offline != 0) {
      return ListTile(
          leading: const Card(
            color: Colors.deepPurpleAccent,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(' Both '),
            ),
          ),
          title: Row(
            children: [
              Text(widget.curBook.BookName),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: ClipOval(
                  child: Container(
                    color: Colors.red,
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text(
                        widget.curBook.Availability.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: Text(widget.curBook.Author),
          onTap: () {
            widget.ontap();
          });
    } else if (widget.curBook.Type & Avail.Online == 0) {
      return ListTile(
          leading: const Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Offline'),
            ),
          ),
          title: Row(
            children: [
              Text(widget.curBook.BookName),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: ClipOval(
                  child: Container(
                    color: Colors.red,
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text(
                        widget.curBook.Availability.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          trailing: Text(widget.curBook.Author),
          onTap: () {
            widget.ontap();
          });
    } else {
      return ListTile(
          leading: const Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Online'),
              )),
          title: Text(widget.curBook.BookName),
          trailing: Text(widget.curBook.Author),
          onTap: () {
            widget.ontap();
          });
    }
  }
}
