import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:library_management/Constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:library_management/Network.dart';

class BookDetails {
  late String bookName;
  late String availability;
  late String author;
  late int state;

  BookDetails(this.bookName, this.availability, this.author, this.state);
}

class SearchBar extends StatefulWidget {
  String id;

  SearchBar(this.id);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  static const historyLength = 5;
  final List<BookDetails> _searchHistory = [];
  String prevQuery = "";
  List<Widget> filteredSearchHistory = [];
  late FloatingSearchBarController controller;

  void fetch(String name) async {
    final channel = WebSocketChannel.connect(webSocket());
    List<Widget> ret = [];
    channel.sink.add(parser([widget.id, Handler.Nikhil, Search.BookName, name]));
    channel.stream.listen((event) {
      List<String> lis = commands(event);
      int index = 1;
      int size = int.parse(lis[0]);
      lis.removeAt(0);
      while (index * size+size   <= lis.length) {
        ret.add(listItem(
          ontap: () {
            addSearchTerm(getByName(name));
            selectedTerm = name;
            controller.close();
          },
          curBook: BookDetails(lis[index * (size)], lis[index * (size) + 4],
              lis[index * (size) + 3], int.parse(lis[index * (size) + 5])),
        ));
        index++;
      }
      print(ret.length);
      filteredSearchHistory = ret;
      prevQuery = name;
      channel.sink.close();
      setState(() {});
    });
  }

  String selectedTerm = '';

  void addSearchTerm(BookDetails term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    print(_searchHistory);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
  }

  void deleteSearchTerm(BookDetails term) {
    _searchHistory.removeWhere((t) => t == term);
  }

  BookDetails getByName(String name) {
    return _searchHistory.where((element) => element.author == name).first;
  }

  void putSearchTermFirst(BookDetails term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  List<Widget> HistoryWidgets(List<BookDetails> details) {
    List<Widget> widgets = details
        .map((bookDetails) => listItem(
        ontap: () {
          addSearchTerm(getByName(bookDetails.bookName));
          selectedTerm = bookDetails.bookName;
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
            addSearchTerm(getByName(query));
            selectedTerm = query;
          });
          controller.close();
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
  BookDetails curBook;
  listItem({required this.ontap, required this.curBook});

  @override
  _listItemState createState() => _listItemState();
}

class _listItemState extends State<listItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.curBook.state & Avail.Online != 0 &&
        widget.curBook.state & Avail.Offline != 0) {
      return ListTile(
          leading: const Card(
            color: Colors.deepPurpleAccent,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Both'),
            ),
          ),
          title: Row(
            children: [
              ClipOval(
                child: Container(
                  color: Colors.red,
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      widget.curBook.availability,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Text(widget.curBook.bookName),
            ],
          ),
          trailing: Text(widget.curBook.author),
          onTap: () {
            widget.ontap();
          });
    } else if (widget.curBook.state & Avail.Online == 0) {
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
              ClipOval(
                child: Container(
                  color: Colors.red,
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      widget.curBook.availability,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Text(widget.curBook.bookName),
            ],
          ),
          trailing: Text(widget.curBook.author),
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
          title: Text(widget.curBook.bookName),
          trailing: Text(widget.curBook.author),
          onTap: () {
            widget.ontap();
          });
    }
  }
}
