import 'package:flutter/material.dart';
import 'tradetoptabs.dart';
import 'financetoptabs.dart';
import 'models/supplier.dart';
import 'app_state_container.dart';


class SupplierPage extends StatefulWidget {
  static String tag = 'suppliers-page';

  final Supplier supplier;

  SupplierPage(this.supplier);

  @override
  _SupplierPageState createState() {
    return _SupplierPageState(this.supplier);
  }
}


class _SupplierPageState extends State<SupplierPage> {

  final Supplier supplier;

  _SupplierPageState(this.supplier);

  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final currency = inheritedWidget.getCurrency();

    final profileTab = ListView(
      children: <Widget>[
        /*
        ListTile(
          leading: Text('Update User Info', style: TextStyle(fontSize: 20.0)),
          title: Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            },
            activeColor: Colors.green,
          ),
        ),
        Divider(color: Colors.grey),
        */
        ListTile(
          leading: Icon(Icons.person),
          title: Text('First name: ' + supplier.firstName),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Last name: ' + supplier.lastName),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.location_city),
          title: Text('Community: ' + supplier.community),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('${supplier.phone}'),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Gender:  ${supplier.gender}'),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.code),
          title: Text('Membership code:  ${supplier.membershipCode}'),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text('Account Balance:  ${currency.symbol} ${supplier.accountBalance}'),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text('Since: ' + supplier.createdAt.toString()),
        ),
        Divider(color: Colors.grey),
        ListTile(
          leading: Icon(Icons.date_range),
          title: Text('Last updated: ' + supplier.updatedAt.toString()),
        ),
        Divider(color: Colors.grey),
      ],
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Container(
                    child: Text(
                      'Trade',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'Finance',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'About',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(supplier.toString() + "  -  " + supplier.community),
          ),
          body: TabBarView(
            children: <Widget>[
              TradeTopTabs(this.supplier),//ff5722
              FinanceTopTabs(this.supplier),//3f51b5//2196f3 //4CAF50
              profileTab
            ],
          )),
    );
  }
}
