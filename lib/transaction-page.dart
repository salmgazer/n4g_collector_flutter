import 'package:flutter/material.dart';
import 'models/trade.dart';
import './utils/strings.dart';
import 'app_state_container.dart';


class TransactionPage extends StatelessWidget {
  static String tag = 'transaction-page';
  final Trade transaction;

  const TransactionPage(this.transaction);

  final boxHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['transaction'];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(displayName , style: new TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[500],
        iconTheme: new IconThemeData(color: Colors.white)
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          ListTile(
            title: Text('Field Officer: ${transaction.collector}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Produce: ${transaction.produce}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Sacs: ' + transaction.sacs.toString()),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Yield (kg): ' + transaction.produceYield.toString()),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Cost : GHS ${transaction.cost.toString()}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Paid : GHS ${transaction.amountPaid.toString()}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text(transaction.payment),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Since: ' + transaction.date.toString()),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Updated on: ' + transaction.updatedAt.toString()),
          ),
          Divider(color: Colors.grey),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 16.0),
            child:
            (() {
              return transaction.payment != 'paid' ? Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent.shade100,
                elevation: 5.0,
                color: Colors.greenAccent[700],
                child: MaterialButton(
                  minWidth: 150.0,
                  height: 42.0,
                  onPressed: () {
                    print('About to make payment');
                  },
                  child: Text('Make Payment', style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
              ) : Text('---- Completed Transaction ----', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold));
            }())
          ),
          SizedBox(height: 20)
        ],
      )
    );
  }

}
