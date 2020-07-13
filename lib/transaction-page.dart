import 'package:collector/middleware/AppDb.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'models/trade.dart';
import './utils/strings.dart';
import 'app_state_container.dart';


class TransactionPage extends StatefulWidget {
  static String tag = 'transaction-page';

  final Trade transaction;

  TransactionPage(this.transaction);

  @override
  _TransactionPageState createState() {
    return _TransactionPageState(this.transaction);
  }
}

class _TransactionPageState extends State<TransactionPage> {
  final Trade transaction;

  _TransactionPageState(this.transaction);

  final _formKey = GlobalKey<FormState>();

  final boxHeight = 50.0;

  final TextEditingController costController = TextEditingController();
  final TextEditingController amountPaidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['transaction'];
    final currency = inheritedWidget.getCurrency();

    final change = this.transaction.cost - this.transaction.amountPaid;

    amountPaidController.text = transaction.amountPaid.toString();


    final costField = TextFormField(
      keyboardType: TextInputType.number,
      enabled: true,
      controller: costController,
      decoration: new InputDecoration(
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Enter payment (${currency.symbol})',
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter amount';
        }
        else if (double.parse(value) > change) {
          return 'You can pay ${currency.symbol} $change max';
        }
      },
    );

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
            title: Text('Yield (kg): ' + transaction.yield.toString()),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Cost : GHS ${transaction.cost.toString()}', style: TextStyle(color: Colors.red)),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Other Costs : GHS ${transaction.otherCost.toString()}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Purpose of other costs : ${transaction.otherCostPurpose}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Paid : GHS ${amountPaidController.text}', style: TextStyle(color: Colors.green)),
          ),
          Divider(color: Colors.grey),
          ListTile(
            title: Text('Payment status: ${transaction.payment}'),
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
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Positioned(
                                  right: -40.0,
                                  top: -40.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      child: Icon(Icons.close),
                                      backgroundColor: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text("Change:${currency.symbol} $change"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: costField,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: RaisedButton(
                                          color: Colors.greenAccent[700],
                                          child: Text("Save", style: TextStyle(color: Colors.white)),
                                          onPressed: () async {
                                            if (_formKey.currentState.validate()) {
                                              // _formKey.currentState.save();

                                              final amount = double.parse(costController.text);
                                              transaction.amountPaid = transaction.amountPaid + amount;
                                              amountPaidController.text = transaction.amountPaid.toString();
                                              if (transaction.cost == transaction.amountPaid) {
                                                transaction.payment = 'paid';
                                              }
                                              // _formKey.currentState.save();
                                              print(transaction.toMap());

                                              final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

                                              await AppDb.updateTransactionAmountPaid(transaction.amountPaid, transaction.id, transaction.payment, currentTime);
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
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
