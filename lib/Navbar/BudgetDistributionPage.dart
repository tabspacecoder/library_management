import 'package:flutter/material.dart';

class BudgetDistributionPage extends StatefulWidget {
  const BudgetDistributionPage({Key? key}) : super(key: key);

  @override
  State<BudgetDistributionPage> createState() => _BudgetDistributionPageState();
}

class _BudgetDistributionPageState extends State<BudgetDistributionPage> {

  List<BudgetDistribution> data=[];

  // add to data in fetch
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Budget Distribution'),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: ((context, index) {return ListTile(
            title: Text(data[index].InvestedOn),
            trailing: Text(data[index].Amount),
          ); }),
        ));
  }
}

class BudgetDistribution{
  late String InvestedOn;
  late String Amount;
  BudgetDistribution(this.InvestedOn,this.Amount);
}

// Card c = Card(
//   color: Colors.white,
//   elevation: 3,
//   shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10)
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: SfCartesianChart(
//         primaryXAxis: CategoryAxis(),
//         // Chart title
//         // Enable legend
//         legend: Legend(isVisible: true),
//         // Enable tooltip
//         tooltipBehavior: TooltipBehavior(enable: true),
//         series: <
//             ChartSeries<_YearlyCustomerData, String>>[
//           LineSeries<_YearlyCustomerData, String>(
//               color: canvasColor,
//               dataSource: yearlydata,
//               xValueMapper:
//                   (_YearlyCustomerData data, _) =>
//               data.year,
//               yValueMapper:
//                   (_YearlyCustomerData data, _) =>
//               data.count,
//               name: 'Count',
//               // Enable data label
//               dataLabelSettings:
//               DataLabelSettings(isVisible: true))
//         ]),
//   ),
// ),