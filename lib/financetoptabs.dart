import 'package:collector/middleware/AppDb.dart';
import 'package:flutter/material.dart';
import 'models/supplier.dart';
import 'app_state_container.dart';
import 'models/withdrawal.dart';
import 'models/produce.dart';
import 'components/withdrawal-list-item.dart';
import 'models/user.dart';

class FinanceTopTabs extends StatefulWidget {
  Supplier supplier;
  FinanceTopTabs(this.supplier);

  @override
  _FinanceTopTabsState createState() {
    return _FinanceTopTabsState(supplier);
  }
}

class _FinanceTopTabsState extends State<FinanceTopTabs>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final TextEditingController withdrawalAmountController = TextEditingController();
  final TextEditingController loanPurposeController = TextEditingController();
  final TextEditingController sacsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final boxHeight = 20.0;

  Supplier supplier;
  List<Withdrawal> withdrawals = <Withdrawal>[];

  _FinanceTopTabsState(this.supplier);

  DateTime transactionDate;

  getWithdrawals() async {
    return AppDb.filterSupplierWithdrawals(supplier.id);
  }

  Produce _produce = Produce(-1, '-- Select produce --', 0, DateTime(2019), DateTime(2019));
  List<Produce> _products = <Produce>[];

  @override
  void initState() {
    AppDb.filterProducts().then((fetchedProductsFromDB) => setState(() {
      _products = fetchedProductsFromDB;
      print(_products);
    }));
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  int _currentIndex = 0;
  void onTabTapped(int index) {
    if (index == 1) {
      getWithdrawals().then((fetchedWithdrawals) => setState(() {
        withdrawals = fetchedWithdrawals;
      }));
    }
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final currency = inheritedWidget.getCurrency();

    final user = inheritedWidget.getUser();

    final defaultProduct = _products.firstWhere((product) => product.id.isNegative, orElse: () => null);
    if (defaultProduct == null) {
      _products.insert(0, _produce);
    }

    List<WithdrawalListItem> _buildWithdrawalsList(BuildContext context) {
      withdrawals.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return withdrawals.map((withdrawal) => WithdrawalListItem(withdrawal, currency, supplier, context)).toList();
    }


    final withdrawalsTab = new Container(
        margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
        child: new ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: _buildWithdrawalsList(context)
        )
    );

    // Build a Form widget using the _formKey we created above
    final produceField = new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.nature),
            // labelText: 'Select Produce',
          ),
          isEmpty: _produce == Produce(-1, '-- Select produce --', 0, DateTime(2019), DateTime(2019)),
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _produce,
              isDense: true,
              onChanged: (Produce newProduce) {
                withdrawalAmountController.text = '';
                sacsController.text = '';
                setState(() {
                  _produce = newProduce;
                  state.didChange(newProduce);
                });
              },
              items: _products.map((Produce produce) {
                return new DropdownMenuItem(
                  value: produce,
                  child: new Text(produce.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final sacsField = TextField(
      controller: sacsController,
      onChanged: (text) {
        withdrawalAmountController.text = (double.parse(sacsController.text) * _produce.unitPrice).toString();
      },
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        hintText: 'Number of sacs',
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Number of Sacs',
        icon: const Icon(Icons.add_shopping_cart),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    // Build a Form widget using the _formKey we created above
    final withrawalAmountField = TextFormField(
      keyboardType: TextInputType.number,
      controller: withdrawalAmountController,
      onChanged: (text) {
        sacsController.text = (double.parse(text) / _produce.unitPrice).toString();
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter loan amount';
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
              final amount = double.parse(withdrawalAmountController.text);
              final purpose = loanPurposeController.text;

              final Map newWithdrawal = <String, dynamic>{
                "amount": amount,
                "reason": purpose,
                "collectorId": user.id,
                "supplierId": supplier.id,
                "productId": _produce.id,
                "sacs": double.parse(sacsController.text)
              };

              await AppDb.createOne(Withdrawal.tableName, newWithdrawal);
              await AppDb.updateSupplerAccountBalance(
                  Supplier.tableName, 'subtract', supplier.id, amount);
              supplier = await AppDb.findSupplierById(supplier.id);

              await AppDb.updateUserWallet('users', 'subtract', user.id, amount);

              AppDb.findUserById(user.id).then((userFromDb) => setState(() {
                inheritedWidget.saveUser(new User(
                    userFromDb.id,
                    userFromDb.firstName,
                    userFromDb.lastName,
                    userFromDb.otherNames,
                    userFromDb.email,
                    userFromDb.phone,
                    userFromDb.country,
                    userFromDb.roles,
                    userFromDb.status,
                    userFromDb.community,
                    userFromDb.confirmed,
                    userFromDb.wallet,
                    userFromDb.countryId,
                    userFromDb.createdAt,
                    userFromDb.updatedAt));
              }));
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Withdrawal has been saved"),
              ));
              withdrawalAmountController.text = '';
              loanPurposeController.text = '';
              // _currentIndex = 1;
              // Navigator.of(context).pushNamed(SuppliersPage.tag);
            }
          },
          child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );


    final loanTab = new SingleChildScrollView(
      child:
      Form(
        key: _formKey,
        child: new Container(
          margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
          child: Column(
            children: <Widget>[
              Text(
                'Balance: ${currency.symbol} ' + supplier.accountBalance.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: boxHeight),
              withrawalAmountField,
              SizedBox(height: boxHeight),
              produceField,
              SizedBox(height: boxHeight),
              sacsField,
              SizedBox(height: boxHeight),
              purposeField,
              SizedBox(height: boxHeight),
              formButton
            ],
          ),
        ),
      ),
    );


    final List<Widget> _children = [
      loanTab,
      withdrawalsTab
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped, // new
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.monetization_on),
              title: new Text('Lend'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.history),
              title: new Text('History'),
            )
          ],
        ),
      ),
    );
  }
}