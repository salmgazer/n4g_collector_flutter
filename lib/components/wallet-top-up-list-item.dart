import 'package:collector/models/currency.dart';
import 'package:flutter/material.dart';
import '../models/wallet-top-up.dart';
import '../models/user.dart';
import '../wallet-top-up-page.dart';


class WalletTopUpListItem extends ListTile {

  WalletTopUpListItem(WalletTopUp walletTopUp, User user, Currency currency, BuildContext context) :
        super(
        title : Text( currency.symbol + walletTopUp.amount.toString() + " - " + walletTopUp.createdAt.day.toString()+ "-" +walletTopUp.createdAt.month.toString()+ "-" +walletTopUp.createdAt.year.toString()),
        subtitle: Text('Top up by: ${walletTopUp.byUser}'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WalletTopUpPage(walletTopUp, user)));
        },
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
      );
}