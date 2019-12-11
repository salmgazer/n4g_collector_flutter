import 'package:collector/models/currency.dart';
import 'package:flutter/material.dart';
import '../models/withdrawal.dart';
import '../models/supplier.dart';
import '../withdrawal-page.dart';


class WithdrawalListItem extends ListTile {

  WithdrawalListItem(Withdrawal withdrawal, Currency currency, Supplier supplier, BuildContext context) :
        super(
        title : Text(currency.symbol + "  " + withdrawal.amount.toString() + " - " + withdrawal.createdAt.day.toString()+ "-" +withdrawal.createdAt.month.toString()+ "-" +withdrawal.createdAt.year.toString()),
        subtitle: Text(withdrawal.reason),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawalPage(withdrawal, supplier)));
        },
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
      );
}