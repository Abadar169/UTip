import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/TipCalculatorModel.dart';
import 'package:utip/widgets/person_counter.dart';
import 'package:utip/widgets/tip_slider.dart';
import 'package:utip/widgets/bill_amount.dart';
import 'package:utip/widgets/total_per_person.dart';
import 'package:utip/widgets/tip_row.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => Tipcalculatormodel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UTip(),
    );
  }
}

class UTip extends StatefulWidget {
  const UTip({super.key});

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final model = Provider.of<Tipcalculatormodel>(context);

   
    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTip'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TotalPerPerson(theme: theme, style: style, total: model.totalPerPerson),
          //Form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  BillAmountField(
                    billAmount: model.billTotal.toString(),
                    onChanged: (value) {
                      model.updateBillTotal(double.parse(value));
                    },
                  ),
                  //Split Bill Area
                  PersonCounter(
                    theme: theme,
                    personCount: model.personCount,
                    onDecrement: () {
                      if(model.personCount > 1) {
                        model.updatePersonCount(model.personCount -1);
                      }
                    } ,
                    onIncrement: (){
                      model.updatePersonCount(model.personCount +1);

                    },
                  ),
                  TipRow(theme: theme, billTotal: model.billTotal, percentage: model.tipPercentage,),

                  //slider text
                  Text('${(model.tipPercentage * 100).round()}%'),

                  //tip slider
                  TipSlider(
                    tipPercentage: model.tipPercentage,
                    onChanged: (double value) {
                      model.updateTipPercentage(value);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
