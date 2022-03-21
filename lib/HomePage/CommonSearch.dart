import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:library_management/Constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:library_management/Network.dart';


class SearchBar extends StatefulWidget {
  String id;

  SearchBar(this.id);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  static const historyLength = 5;
  final List<BookData> _searchHistory = [];
  String prevQuery = "";
  List<Widget> filteredSearchHistory = [];
  List<BookData> filteredSearchValues = [];
  late FloatingSearchBarController controller;

  void fetch(String name) async {
    final channel = WebSocketChannel.connect(webSocket());
    List<Widget> ret = [];
    List<BookData> ret1 = [];
    channel.sink.add(parser(packet(widget.id, Handler.Handler1, Search.Books,bookName: name,searchFilter: [BookParams.Name],count: 20,sort: "ASC")));
    channel.stream.listen((event) {
      event = event.split(Header.Split)[1];
      for(dynamic i in jsonDecode(event)["Data"])
        {
          i = jsonDecode(i);
          BookData tmp = BookData(i["ISBN"],i["BookName"],i["Author"],i["Availability"],i["Type"],i["Thumbnail"]);
          ret1.add(tmp);
          ret.add(listItem(
              ontap: () {
                if(filteredSearchHistory.isNotEmpty)
                {
                  addSearchTerm(filteredSearchValues.first);
                  selectedTerm = filteredSearchValues.first.BookName;
                  //controller.close();
                }
              },
              curBook: tmp
          ));
        }

      filteredSearchHistory = ret;
      filteredSearchValues = ret1;
      prevQuery = name;
      channel.sink.close();
      setState(() {});
    });
  }

  String selectedTerm = '';

  void addSearchTerm(BookData term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
  }

  void deleteSearchTerm(BookData term) {
    _searchHistory.removeWhere((t) => t == term);
  }

  BookData getByName(String name) {
    return _searchHistory.where((element) => element.Author == name).first;
  }

  void putSearchTermFirst(BookData term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  List<Widget> HistoryWidgets(List<BookData> details) {
    List<Widget> widgets = details
        .map((bookDetails) => listItem(
        ontap: () {
          if(filteredSearchHistory.isNotEmpty)
          {
            addSearchTerm(filteredSearchValues.first);
            selectedTerm = filteredSearchValues.first.BookName;
          }
        },
        curBook: bookDetails))
        .toList()
        .cast<Widget>();
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FloatingSearchBar(
        controller: controller,
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        title: Text(
          selectedTerm,
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search and find out...',
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        onQueryChanged: (query) {
          setState(() {
            fetch(controller.query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            if(filteredSearchHistory.isNotEmpty)
              {
                addSearchTerm(filteredSearchValues.first);
                selectedTerm = filteredSearchValues.first.BookName;
                //controller.close();
              }

          });

        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (controller.query.isEmpty) {
                    print(HistoryWidgets(_searchHistory).length);
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            'Start searching',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Column(children: HistoryWidgets(_searchHistory))
                        ],
                      ),
                    );
                  } else {
                    if (filteredSearchHistory.isNotEmpty) {
                      return Column(
                        children: filteredSearchHistory,
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("No book found."),
                      );
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class listItem extends StatefulWidget {
  Function ontap;
  BookData curBook;
  listItem({required this.ontap, required this.curBook});

  @override
  _listItemState createState() => _listItemState();
}

class _listItemState extends State<listItem> {
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
