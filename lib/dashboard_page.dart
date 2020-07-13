import 'package:collector/models/models.dart';
import 'package:collector/models/withdrawal.dart';
import 'package:flutter/material.dart';
import 'components/my-drawer.dart';
import './utils/strings.dart';
import 'models/n4gnotification.dart';
import 'components/notification-list-item.dart';
import 'middleware/AppDb.dart';
import 'app_state_container.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'models/trade.dart';


// Create a Form Widget
class DashboardPage extends StatefulWidget {
  static String tag = 'dashboard-page';

  @override
  _DashboardPageState createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> {


  List<N4gNotification> _n4gnotifications = <N4gNotification> [
    N4gNotification(
      1,
      "price",
      "Alidu has changed price of Soya in Boni from 20 to 34",
      "Price is changed from 34 to 45. Price is changed from 34 to 45. Price is changed from 34 to 45. Price is changed from 34 to 45.",
      "Alidu Abu",
      "+233242549545",
      DateTime(2019),
      DateTime(2019)
    ),
    N4gNotification(
      4,
      "shipping",
      "Alidu has shipped 20 sacs of sheanut from Savelugu to Tamale warehouse",
      "Alidu has shipped 20 sacs of shea nut to Tamale warehouse. Truck number is GN 234-14. Driver phone number is: 0245987263.",
      "Alidu Abu",
      "+233242549545",
      DateTime(2019),
      DateTime(2019)
    ),
    N4gNotification(
      2,
      "price",
      "Stephen has changed price of Shea nut in Savelugu from 30 to 34",
      "Price is changed from 34 to 45. Price is changed from 34 to 45. Price is changed from 34 to 45. Price is changed from 34 to 45.",
      "Stephen Anku",
      "+233242549545",
      DateTime(2019),
      DateTime(2019)
    ),
    N4gNotification(
      3,
      "price",
      "George has changed price of Shea nut in Gonja from 40 to 34",
      "Price is changed from 34 to 45 for Gonga west. Price is changed from 34 to 45. Price is changed from 34 to 45. Price is changed from 34 to 45.",
      "Stephen Anku",
      "+233242549545",
      DateTime(2019),
      DateTime(2019)
    ),
  ];

  List<NotificationListItem> _buildNotificationsList(BuildContext context) {
    return _n4gnotifications.map((n4gnotification) => NotificationListItem(n4gnotification, context)).toList();
  }

  static final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Product _product = Product('-1', '-- Select produce --', 0, currentTime, currentTime);
  List<Product> _products = <Product>[];
  List<Trade> _trades = <Trade>[];
  Currency _currency;
  List<Withdrawal> _withdrawals = <Withdrawal>[];

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  @override
  void initState() {
    print("About to filter withdrawals");
    AppDb.filterWithdrawals().then((fetchedWithdrawalsFromDB) => setState(() {
      _withdrawals =  fetchedWithdrawalsFromDB;
    }));

    AppDb.filterProducts().then((fetchedProductsFromDB) => setState(() {
      _products = fetchedProductsFromDB;
    }));
    
    AppDb.filterTransactions().then((fetchedTradesFromDB) => setState(() {
      _trades = fetchedTradesFromDB;
    }));

    super.initState();
  }

  List<Card> _buildProductsTiles(BuildContext context) {
    return _products.map((product) {
      double productsCostTotal = 0;
      double productsSacsCountTotal = 0;

      List<Trade> productTrades = this._trades.where((trade) => trade.produceId == product.id).toList();
      productTrades.forEach((trade) {
        productsCostTotal += trade.amountPaid;
        productsSacsCountTotal += trade.sacs;
      });

      return Card(
        margin: new EdgeInsets.only(top: 20.0),
        child: new Container(
            padding: new EdgeInsets.all(32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(product.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.brown)),
                new Text('Total cost: ${_currency.symbol} ${productsCostTotal.toString()}', style: TextStyle(fontSize: 20)),
                new Text('Sacs: ${productsSacsCountTotal.toString()}', style: TextStyle(fontSize: 20)),
              ],
            )
          ));
    }).toList();
  }

  List<Card> _buildWithdrawalsProductsTiles(BuildContext context) {
    return _products.map((product) {
      double productTotal = 0;
      double productsSacsCountTotal = 0;

      if (this._withdrawals != null) {
        List<Withdrawal> productWithdrawals = this._withdrawals.where((
            withdrawal) => withdrawal.productId == product.id).toList();
        productWithdrawals.forEach((withdrawal) {
          productTotal += withdrawal.amount;
          productsSacsCountTotal += withdrawal.sacs;
        });
      }

      return Card(
          margin: new EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
          child: new Container(
              padding: new EdgeInsets.all(32.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(product.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.brown)),
                  new Text('Total money lent: ${_currency.symbol} ${productTotal.toString()}', style: TextStyle(fontSize: 18)),
                  new Text('Expected number of sacs: ${productsSacsCountTotal.toString()}', style: TextStyle(fontSize: 18))
                ],
              )
          ));
    }).toList();
  }

  final _formKey = GlobalKey<FormState>();
  final boxHeight = 20.0;



  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    _currency = inheritedWidget.getCurrency();

    final displayName = labels[appLanguage]['dashboard'];

    final fromDateField = DateTimePickerFormField(
      inputType: InputType.both,
      format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
      editable: true,
      controller: fromDateController,
      decoration: InputDecoration(
          icon: const Icon(Icons.date_range),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          labelText: 'From', hasFloatingPlaceholder: false
      ),
      validator: (value) {
        if (value == null) {
          return 'Please enter date of transaction';
        }
      },
      onChanged: (dt) => setState(() => {
        print("Date has changed")
      }),
    );

    final toDateField = DateTimePickerFormField(
      inputType: InputType.both,
      format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
      editable: true,
      controller: toDateController,
      decoration: InputDecoration(
          icon: const Icon(Icons.date_range),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          labelText: 'To', hasFloatingPlaceholder: false,
      ),
      validator: (value) {
        if (value == null) {
          return 'Please enter date of transaction';
        }
      },
      onChanged: (dt) => setState(() => {
        print("Date has changed")
      }),
    );

    final salesTab = new Material(
      child: new Container(
        padding: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: ListView(
                children: _buildProductsTiles(context),
              ),
            ),
          ],
        ),
      )
    );

    final transactionsTab = new Material(
      child: ListView(
        children: _buildProductsTiles(context)
      ),
    );

    final withdrawalsTab = new Material(
      child: ListView(
          children: _buildWithdrawalsProductsTiles(context)
      ),
    );

    final notificationsTab = Center(
      child: new Container(
        margin: new EdgeInsets.only(left: 15.0, right: 15.0, top: 40.0, bottom: 30),
        child: ListView(
          children: _buildNotificationsList(context),
        )
      )
    );


    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: new MyDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              /*Tab(icon: Icon(Icons.notifications_active), text: labels[appLanguage]['notifications']),*/
              Tab(icon: Icon(Icons.shopping_cart), text: labels[appLanguage]['purchhases']),
              // Tab(icon: Icon(Icons.attach_money), text: labels[appLanguage]['loans']),
            ],
          ),
          title: Text(displayName),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              salesTab,
              // withdrawalsTab,
            ],
          ),
        )
      ),
    );
  }
}

