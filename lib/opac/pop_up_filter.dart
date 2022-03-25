
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:library_management/HomePage/Home.dart';
// import 'placeholderTemp.dart';

class placeHolder extends StatelessWidget {
  String username;
  placeHolder({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Container(
        child: Text(username),
      ),
    );
  }
}

class popUpFilterButton extends StatefulWidget {
  @override
  _popUpFilterButtonState createState() => _popUpFilterButtonState();
}

class _popUpFilterButtonState extends State<popUpFilterButton> {
  bool value = false;
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  void selectedItem(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('Author');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeHolder(username:"temp" )));

        setState(() {});
        break;
      case 1:
        print('ISBN');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeHolder(username:"temp" )));
        setState(() {});
        break;
      case 2:
        print('logout');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => placeHolder(username:"temp" )));
        // Navigator.pop(context);
        break;
    }
  }

  Widget build(BuildContext context)  {
    return PopupMenuButton<int>(
      child: Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(
          Icons.filter_list,
        ),
      ),
      itemBuilder: (context) =>  [

        PopupMenuItem(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) { return Row(
              children:  [
                Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Author'),
                SizedBox(
                  width: 75,
                ),
                Checkbox(
                  value: this.value1,
                  onChanged: (bool? value) {
                    setState(() {
                      this.value1 = value!;
                    });
                  },
                ),
              ],
            ); },
          ),
          value: 1,
        ),
        PopupMenuItem(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) { return Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('ISBN'),
                SizedBox(
                  width: 85,
                ),
                Checkbox(
                  value: this.value2,
                  onChanged: (bool? value) {
                    setState(() {
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.blue,
                      );
                      this.value2 = value!;
                    });
                  },
                ),
              ],
            ); },

          ),
          value: 2,
        ),
        PopupMenuItem(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) { return Row(
              children:  [
                Icon(
                  Icons.assignment_outlined,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Title'),
                SizedBox(
                  width: 89,
                ),
                Checkbox(
                  value: this.value3,
                  onChanged: (bool? value) {
                    setState(() {
                      this.value3 = value!;
                    });
                  },
                ),

              ],
            ); },

          ),
          value: 3,
        ),
        PopupMenuItem(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) { return Row(
              children:  [
                Icon(
                  Icons.apps_outlined,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Features'),
                SizedBox(
                  width: 60,
                ),
                Checkbox(
                  value: this.value,
                  onChanged: (bool? value)  {
                    setState(() {
                      this.value = value!;
                    });
                  },
                ),

              ],
            ); },
          ),
          value: 4,
        ),

      ],

      onSelected: null,
    );
  }
}

