import 'package:flutter/material.dart';
import 'models/supplier.dart';
import 'models/produce.dart';
import 'middleware/AppDb.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'app_state_container.dart';
import './utils/strings.dart';
import 'components/transaction-list-item.dart';
import 'models/trade.dart';
import 'models/user.dart';


class TradeTopTabs extends StatefulWidget {
  Supplier supplier;
  TradeTopTabs(this.supplier);
  _TradeTopTabsState createState() => _TradeTopTabsState(supplier);
}

class _TradeTopTabsState extends State<TradeTopTabs>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Produce _produce = Produce(-1, '-- Select produce --', 0, DateTime(2019), DateTime(2019));
  List<Produce> _products = <Produce>[];

  @override
  void initState() {
    AppDb.filterProducts().then((fetchedProductsFromDB) => setState(() {
      _products = fetchedProductsFromDB;
      print(_products);
    }));
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  final TextEditingController sacsController = TextEditingController();
  final TextEditingController yieldController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController amountPaidController = TextEditingController();
  final TextEditingController otherCostController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController otherCostPurposeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final boxHeight = 10.0;

  final Supplier supplier;

  _TradeTopTabsState(this.supplier);

  //const _BuyPageState(Supplier);

  List<Trade> transactions = <Trade>[];
  DateTime transactionDate;


  getTransactions() {
    return AppDb.filterSupplierTransactions(supplier.id);
  }

  List<TransactionListItem> _buildTransactionList(BuildContext context) {
    return this.transactions.map((transaction) => TransactionListItem(transaction, context)).toList();
  }

  int _currentIndex = 0;
  void onTabTapped(int index) {
    if (index == 1) {
      getTransactions().then((fetchedTransactions) => setState(() {
        transactions = fetchedTransactions;
      }));
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final currency = inheritedWidget.getCurrency();
    // final products = inheritedWidget.getProducts();
    // _products = products;
    print("##############");
    final defaultProduct = _products.firstWhere((product) => product.id.isNegative, orElse: () => null);
    if (defaultProduct == null) {
      _products.insert(0, _produce);
    }

    final user = inheritedWidget.getUser();


    final displayName = labels[appLanguage]['buy_from'];

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
                setState(() {
                  _produce = newProduce;
                  state.didChange(newProduce);
                });
                costController.text = (double.parse(sacsController.text.length == 0 ? "0" : sacsController.text) * newProduce.unitPrice).toString();
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
        costController.text = (double.parse(sacsController.text) * _produce.unitPrice).toString();
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

    final produceYieldField = TextFormField(
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        hintText: 'Yield in (Kg)',
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Yield in (Kg)',
        icon: const Icon(Icons.widgets),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    final transactionDateField = DateTimePickerFormField(
      inputType: InputType.both,
      format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
      editable: true,
      controller: dateController,
      decoration: InputDecoration(
          icon: const Icon(Icons.date_range),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          labelText: 'Date of transaction', hasFloatingPlaceholder: false
      ),
      validator: (value) {
        if (value == null) {
          return 'Please enter date of transaction';
        }
      },
      onChanged: (dt) => setState(() => transactionDate = dt),
    );

    final costField = TextFormField(
      keyboardType: TextInputType.number,
      enabled: false,
      controller: costController,
      decoration: new InputDecoration(
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Total ${currency.symbol}',
        icon: const Icon(Icons.account_balance),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    final otherCostField = TextField(
      keyboardType: TextInputType.number,
      controller: otherCostController,
      decoration: new InputDecoration(
        hintText: 'Other costs (${currency.symbol})',
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Other costs (${currency.symbol})',
        icon: const Icon(Icons.account_balance),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      onChanged: (text) {
        costController.text = (
            (double.parse(sacsController.text) * _produce.unitPrice) +
                double.parse(otherCostController.text)).toString();
      },
    );

    final otherCostPurpose = TextFormField(
      maxLines: 2,
      controller: otherCostPurposeController,
      decoration: new InputDecoration(
        hintText: 'Purpose of other costs',
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Purpose of other costs',
        icon: const Icon(Icons.account_balance),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.isEmpty && otherCostController.text.isNotEmpty) {
          return 'Please enter purpose of other costs';
        }
      },
    );

    final amountPaidField = TextFormField(
      keyboardType: TextInputType.number,
      controller: amountPaidController,
      decoration: new InputDecoration(
        hintText: 'Amount Paid (${currency.symbol})',
        labelStyle: TextStyle(color: Colors.brown),
        labelText: 'Amount Paid (${currency.symbol})',
        icon: const Icon(Icons.account_balance_wallet),
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter amount paid';
        }
        else if (double.parse(value) > double.parse(costController.text)) {
          return 'You cannot pay more than ${currency.symbol}' + costController.text;
        }
      },
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
            print(supplier.accountBalance);
            if (_formKey.currentState.validate()) {

              final amountPaid = double.parse(amountPaidController.text);
              final cost = double.parse(costController.text);
              var payment;

              if (amountPaid == cost) {
                payment = 'paid';
              } else if (amountPaid == 0 || amountPaid == null) {
                payment = 'unpaid';
              } else {
                payment = 'partially paid';
              }

              final Map newTrade = <String, dynamic>{
                "date": dateController.text,
                "payment": payment,
                "cost": cost,
                "amountPaid": amountPaid,
                "productId": _produce.id,
                "supplierId": supplier.id,
                "collectorId": user.id,
                "sacs": sacsController.text,
                "yield": yieldController.text,
                "otherCost": otherCostController.text,
                "otherCostPurpose": otherCostPurposeController.text,
                "currencyId": currency.id
              };

              final savedTrade = await AppDb.createOne(Trade.tableName, newTrade);
              if (savedTrade != null) {
                // subtract from wallet
                await AppDb.updateUserWallet('users', 'subtract', user.id, amountPaid);

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

                amountPaidController.text = '';
                otherCostPurposeController.text = '';
                costController.text = '';
                otherCostController.text = '';
                dateController.text = '';
                sacsController.text = '';
                yieldController.text = '';
                _produce = Produce(-1, '-- Select produce --', 0, DateTime(2019), DateTime(2019));
              }
              // Navigator.of(context).pushNamed(SuppliersPage.tag);
            }
          },
          child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );

    final tradesTab = new SingleChildScrollView(
      child:
      Form(
        key: _formKey,
        child: new Container(
          margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // formLabel,
              // SizedBox(height: boxHeight),
              produceField,
              SizedBox(height: boxHeight),
              sacsField,
              SizedBox(height: boxHeight),
              produceYieldField,
              SizedBox(height: boxHeight),
              transactionDateField,
              SizedBox(height: boxHeight),
              otherCostField,
              SizedBox(height: boxHeight),
              otherCostPurpose,
              SizedBox(height: boxHeight),
              costField,
              SizedBox(height: boxHeight),
              amountPaidField,
              SizedBox(height: boxHeight),
              formButton,
              SizedBox(height: boxHeight),
            ],
          ),
        ),
      ),
    );

    final transactionsTab = ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _buildTransactionList(context)
    );


    final List<Widget> _children = [
      tradesTab,
      transactionsTab,
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
              icon: new Icon(Icons.shopping_basket),
              title: new Text('Buy'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.shopping_cart),
              title: new Text('Transactions'),
            )
          ],
        ),
      ),
    );
  }
}