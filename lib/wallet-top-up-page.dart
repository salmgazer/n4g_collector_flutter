import 'package:flutter/material.dart';
import 'models/wallet-top-up.dart';
import 'models/user.dart';
import './utils/strings.dart';
import 'app_state_container.dart';
import 'middleware/AppDb.dart';



class WalletTopUpPage extends StatefulWidget {
  WalletTopUp walletTopUp;
  User user;
  WalletTopUpPage(this.walletTopUp, this.user);

  @override
  _WalletTopUpPageState createState() {
    return _WalletTopUpPageState(walletTopUp, user);
  }
}

class _WalletTopUpPageState extends State<WalletTopUpPage> {
  static String tag = 'wthdrawal-page';
  WalletTopUp walletTopUp;
  final User user;

  final _formKey = GlobalKey<FormState>();

  _WalletTopUpPageState(this.walletTopUp, this.user);

  final boxHeight = 50.0;

  final TextEditingController walletTopUpAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['wallet'];

    final user = inheritedWidget.getUser();

    walletTopUpAmountController.text = walletTopUp.amount.toString();

    final detailsTab = new ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: [
        ListTile(
          title: Text('Amount: ' + walletTopUp.amount.toString()),
        ),
        Divider(color: Colors.grey),
        ListTile(
          title: Text('Since: ' + walletTopUp.createdAt.toString()),
        ),
        Divider(color: Colors.grey),
        ListTile(
          title: Text('Updated on: ' + walletTopUp.updatedAt.toString()),
        ),
        SizedBox(height: 20)
      ],
    );


    // components of editTab

    // Build a Form widget using the _formKey we created above
    final withrawalAmountField = TextFormField(
      keyboardType: TextInputType.number,
      controller: walletTopUpAmountController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter loan amount';
        }
      },
      decoration: new InputDecoration(
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'GHS',
        icon: const Icon(Icons.monetization_on),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),

    );


    final formButton = new Container(
      margin: EdgeInsets.only(left: 45.0, right: 40.0, top: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: Colors.greenAccent[700],
        child: MaterialButton(
          minWidth: 300.0,
          height: 42.0,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              final amount = walletTopUpAmountController.text;

              final Map newWalletTopUp = <String, dynamic>{
                "amount": amount,
                "forUserId": user.userId,
                "byUserId": user.userId,
                "id": walletTopUp.id
              };

              try {
                await AppDb.update(WalletTopUp.tableName, newWalletTopUp);
                await AppDb.updateUserWallet('users', 'add', user.userId, double.parse(walletTopUp.amount.toString()));
                await AppDb.updateUserWallet('users', 'subtract', user.userId, double.parse(amount));
                walletTopUpAmountController.text = amount;

                AppDb.findUserById(user.userId).then((userFromDb) => setState(() {
                  inheritedWidget.saveUser(new User(
                      userFromDb.userId,
                      userFromDb.firstName,
                      userFromDb.otherNames,
                      userFromDb.phone,
                      userFromDb.status,
                      userFromDb.gender,
                      userFromDb.password,
                      userFromDb.createdAt,
                      userFromDb.updatedAt));
                }));
              } catch(err) {
                print(err);
              }
              // Navigator.of(context).pushNamed(SuppliersPage.tag);
            }
          },
          child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );

    final deleteButton = new Container(
      margin: EdgeInsets.only(left: 45.0, right: 40.0, top: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: Colors.redAccent,
        child: MaterialButton(
          minWidth: 300.0,
          height: 42.0,
          onPressed: () async {
            await AppDb.delete(WalletTopUp.tableName, walletTopUp.id);
            print('deleted');
          },
          child: Text('Delete', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );

    final editTab = new SingleChildScrollView(
      child:
      Form(
        key: _formKey,
        child: new Container(
          margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: boxHeight),
              withrawalAmountField,
              SizedBox(height: boxHeight),
              formButton,
            ],
          ),
        ),
      ),
    );


    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                    text: labels[appLanguage]['details']),
                Tab(
                    text: labels[appLanguage]['edit'])
              ],
            ),
            title: Text("Wallet Top Up"),
          ),
          body: Form(
            child: TabBarView(
              children: [
                detailsTab,
                editTab,
              ],
            ),
          )),
    );
  }

}
