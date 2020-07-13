import 'package:collector/middleware/AppDb.dart';
import 'package:collector/models/wallet-top-up.dart';
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'app_state_container.dart';
import 'components/wallet-top-up-list-item.dart';
import 'components/my-drawer.dart';
import './utils/strings.dart';

class WalletPage extends StatefulWidget {
  static String tag = 'wallet-page';
  WalletPage();

  @override
  _WalletPageState createState() {
    return _WalletPageState();
  }
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {

  final TextEditingController walletTopUpAmountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final boxHeight = 20.0;

  var _wallet;

  List<WalletTopUp> walletTopUps = <WalletTopUp>[];

  _WalletPageState();

  DateTime transactionDate;

  var myUser;
  var currency;
  getWalletTopUps() async {
    return AppDb.filterWalletTopUps(myUser.id);
  }

  List<WalletTopUpListItem> _buildWalletTopUpList(BuildContext context) {
    walletTopUps.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return walletTopUps.map((walletTopUp) => WalletTopUpListItem(walletTopUp, myUser, currency, context)).toList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    walletTopUpAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    currency = inheritedWidget.getCurrency();

    myUser = inheritedWidget.getUser();
    _wallet = myUser.wallet;


    final walletTopUpsTab = new Container(
        margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
        child: new ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: _buildWalletTopUpList(context)
        )
    );

    // Build a Form widget using the _formKey we created above
    final walletTopUpAmountField = TextFormField(
      keyboardType: TextInputType.number,
      controller: walletTopUpAmountController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter top up amount';
        }
      },
      decoration: new InputDecoration(
        labelStyle: TextStyle(color: Colors.brown),
        labelText: currency.symbol,
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
                "forUserId": myUser.id,
                "byUserId": myUser.id,
              };

              await AppDb.createOne(WalletTopUp.tableName, newWalletTopUp);
              await AppDb.updateUserWallet(
                  User.tableName, 'add', myUser.id, double.parse(amount));
              // user = await AppDb.findSupplierById(supplier.id);
              AppDb.findUserById(myUser.id).then((userFromDb) => setState(() {
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
             print("About to save");
              walletTopUpAmountController.text = '';
              // _currentIndex = 1;
            }
          },
          child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );


    final newTopUpTab = new SingleChildScrollView(
      child:
      Form(
        key: _formKey,
        child: new Container(
          margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
          child: Column(
            children: <Widget>[
              Text(
                'Balance: ${currency.symbol} ' + _wallet.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: boxHeight),
              walletTopUpAmountField,
              SizedBox(height: boxHeight),
              formButton
            ],
          ),
        ),
      ),
    );


    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              onTap: (index) {
                if (index == 1) {
                  getWalletTopUps().then((fetchedWalletTopUps) => setState(() {
                    walletTopUps = fetchedWalletTopUps;
                  }));
                } else {
                  AppDb.findUserById(myUser.id).then((fetchedUser) => setState(() {
                    myUser = fetchedUser;
                    _wallet = myUser.wallet;
                  }));
                }
              },
              tabs: [
                Tab(
                    icon: Icon(Icons.add),
                    text: labels[appLanguage]['topup']),
                Tab(
                  icon: Icon(Icons.history),
                  text: labels[appLanguage]['history'],
                ),
              ],
            ),
            title: Text('My Wallet'),
          ),
          body: Form(
            child: TabBarView(
              children: [
                newTopUpTab,
                walletTopUpsTab,
              ],
            ),
          )),
    );
  }
}