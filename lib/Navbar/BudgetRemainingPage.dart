import 'package:flutter/material.dart';

class BudgetRemainingPage extends StatefulWidget {
  const BudgetRemainingPage({Key? key}) : super(key: key);

  @override
  State<BudgetRemainingPage> createState() => _BudgetRemainingPageState();
}

class _BudgetRemainingPageState extends State<BudgetRemainingPage> {

  List<remainingBudget> data=[];

  // add to data in fetch
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remaining Budget'),
      ),
      body: ListView.builder(
      itemCount: data.length,
      itemBuilder: ((context, index) {return ListTile(
        title: Text(data[index].type),
        trailing: Text(data[index].sum),
    ); }),
    ));
  }
}

class remainingBudget{
  late String type;
  late String sum;
  remainingBudget(this.type,this.sum);
}