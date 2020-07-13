import 'package:flutter/material.dart';
import 'models/withdrawal.dart';
import 'models/supplier.dart';
import 'models/user.dart';
import './utils/strings.dart';
import 'app_state_container.dart';
import 'middleware/AppDb.dart';



class WithdrawalPage extends StatefulWidget {
  Withdrawal withdrawal;
  Supplier supplier;
  WithdrawalPage(this.withdrawal, this.supplier);

  @override
  _WithdrawalPageState createState() {
    return _WithdrawalPageState(withdrawal, supplier);
  }
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  static String tag = 'wthdrawal-page';
  final Withdrawal withdrawal;
  final Supplier supplier;

  final _formKey = GlobalKey<FormState>();

  _WithdrawalPageState(this.withdrawal, this.supplier);

  final boxHeight = 50.0;

  final TextEditingController withdrawalAmountController = TextEditingController();

  final TextEditingController loanPurposeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['withdrawal'];
    final currency = inheritedWidget.getCurrency();

    final user = inheritedWidget.getUser();

    withdrawalAmountController.text = withdrawal.amount.toString();
    loanPurposeController.text = withdrawal.reason;

    final detailsTab = new ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: [
        ListTile(
          title: Text('Amount: ' + currency.symbol+ ' ' + withdrawal.amount.toString()),
        ),
        Divider(color: Colors.grey),
        ListTile(
          title: Text('Since: ' + withdrawal.createdAt.toString()),
        ),
        Divider(color: Colors.grey),
        ListTile(
          title: Text('Purpose: ' + withdrawal.reason),
        ),
        Divider(color: Colors.grey),
        ListTile(
          title: Text('Updated on: ' + withdrawal.updatedAt.toString()),
        ),
        SizedBox(height: 20)
      ],
    );


    // components of editTab

    // Build a Form widget using the _formKey we created above
    final withrawalAmountField = TextFormField(
      keyboardType: TextInputType.number,
      controller: withdrawalAmountController,
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

    final purposeField = TextFormField(
      maxLines: 4,
      controller:loanPurposeController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter purpose of loan';
        }
      },
      decoration: new InputDecoration(
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Expected returns (purpose of loan)',
        icon: const Icon(Icons.message),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    final formButton = new Container(
      margin: EdgeInsets.only(left: 45.0, right: 40.0, top: 5.0),
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
              final amount = withdrawalAmountController.text;
              final purpose = loanPurposeController.text;

              final Map newWithdrawal = <String, dynamic>{
                "amount": amount,
                "reason": purpose,
                "collectorId": user.userId,
                "supplierId": supplier.id,
                "id": withdrawal.id
              };

              try {
                await AppDb.update(Withdrawal.tableName, newWithdrawal);

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
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Withdrawal has been saved"),
                ));
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
            await AppDb.delete(Withdrawal.tableName, withdrawal.id);
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
              purposeField,
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
            title: Text('Withdrawal (${currency.symbol} ${withdrawal.amount})'),
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
