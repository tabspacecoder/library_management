import 'package:flutter/material.dart';

class BudgetTotalPage extends StatefulWidget {
  const BudgetTotalPage({Key? key}) : super(key: key);

  @override
  State<BudgetTotalPage> createState() => _BudgetTotalPageState();
}

class _BudgetTotalPageState extends State<BudgetTotalPage> {

  List<totalBudget> data=[];

  // add to data in fetch
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Total Budget'),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: ((context, index) {return ListTile(
            leading: Text(data[index].BudgetID),
            title: Text(data[index].Src),
            subtitle: Text(data[index].type),
            trailing: Text('Amount - ${data[index].Amount} ,Used Amount - ${data[index].UsedAmt}'),
          ); }),
        ));
  }
}

class totalBudget{
  late String type;
  late String BudgetID, Src, Amount, UsedAmt;
  totalBudget(this.BudgetID,this.Src,this.Amount,this.UsedAmt,this.type);
}