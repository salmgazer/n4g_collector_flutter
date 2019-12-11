import 'package:flutter/material.dart';
import '../models/trade.dart';
import '../transaction-page.dart';


class TransactionListItem extends ListTile {

  TransactionListItem(Trade transaction, BuildContext context) :
        super(
        title : Text(transaction.produce + " - " + transaction.date),
        subtitle: Text(transaction.payment+ '  -  ' + transaction.sacs.toString() + "sacs"),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage(transaction)));
        },
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
      );
}