import 'package:flutter/material.dart';
import 'components/my-drawer.dart';
import 'models/currency.dart';
import 'models/product.dart';
import './utils/strings.dart';
import 'models/language.dart';
import 'models/community.dart';
import 'app_state_container.dart';
import 'middleware/AppDb.dart';

// Create a Form Widget
class SettingsPage extends StatefulWidget {
  static String tag = 'settings-page';

  @override
  _SettingsPageState createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {

  List<Currency> _currencies = <Currency>[];

  List<Language> _languages = <Language>[
    Language('1', 'English', 'eng'),
    Language('2', 'French', 'fra'),
  ];

  static final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  Community _community = Community('-1', '-- Select community --', currentTime, currentTime);
  List<Community> _communities = <Community>[];


  Product _product = Product('-1', '-- Select produce --', 0, currentTime, currentTime);
  List<Product> _products = <Product>[];

  Currency _currency = Currency('-1', '-- Select currency --', '--');
  Language _language = Language('-1', '-- Select language --', '--');


  final _formKey = GlobalKey<FormState>();
  final boxHeight = 20.0;

  getLanguages() async {
    return AppDb.filterLanguages();
  }

  getCurrencies() async {
    return AppDb.filterCurrencies();
  }
  
  @override
  void initState() {
    getCurrencies().then((fetchedCurrencies) => setState(() {
      _currencies = fetchedCurrencies;
      _currencies.insert(0, _currency);
    }));

    /*
    getLanguages().then((fetchedLanguages) => setState(() {
      _languages = fetchedLanguages;
      _languages.insert(0, _language);
    }));
    */

    AppDb.filterCommunities().then((fetchedCommunities) => setState(() {
      print(fetchedCommunities);
      _communities = fetchedCommunities;
      _communities.insert(0, _community);
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['settings'];

    final communities = inheritedWidget.getCommunities();
    _communities = communities;
    if (_communities == null) {
      _communities = <Community>[];
      _communities.insert(0, _community);
    } else {
      final defaultCommunity = _communities.firstWhere((community) =>
      community.id == '-1', orElse: () => null);
      if (defaultCommunity == null) {
        _communities.insert(0, _community);
      }
    }

    final products = inheritedWidget.getProducts();
    _products = products;

    if (_products == null) {
      _products = <Product>[];
    }
    final defaultProduct = _products.firstWhere((product) => product.id == '-1', orElse: () => null);
    if (defaultProduct == null) {
      _products.insert(0, _product);
    }

    final currentCurrency = inheritedWidget.getCurrency();

    final communityField = new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.location_on),
            // labelText: 'Community',
          ),
          isEmpty: _community == Community('-1', '-- Select community --', currentTime, currentTime),
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _community,
              isDense: true,
              onChanged: (Community newCommunity) {
                setState(() {
                  _community = newCommunity;
                  state.didChange(newCommunity);
                });
              },
              items: _communities.map((Community community) {
                return new DropdownMenuItem(
                  value: community,
                  child: new Text(community.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

  final currencyField = new FormField(
    builder: (FormFieldState state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          icon: const Icon(Icons.attach_money),
          // labelText: 'currency',
        ),
        isEmpty: _currency == Currency('-1', '-- Select currency --', '--'),
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: _currency,
            isDense: true,
            onChanged: (Currency newCurrency) {
              setState(() {
                _currency = newCurrency;
                inheritedWidget.setCurrency(newCurrency);
                state.didChange(newCurrency);
              });
            },
            items: _currencies.map((Currency currency) {
              return new DropdownMenuItem(
                value: currency,
                child: new Text(currency.name),
              );
            }).toList(),
          ),
        ),
      );
    },
  );

  final produceField = new FormField(
    builder: (FormFieldState state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          icon: const Icon(Icons.library_books),
          // labelText: 'produce',
        ),
        isEmpty: _product == Product('-1', '-- Select produce --', 0, currentTime, currentTime),
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: _product,
            isDense: true,
            onChanged: (Product newProduct) {
              setState(() {
                _product = newProduct;
                state.didChange(newProduct);
              });
            },
            items: _products.map((Product product) {
              return new DropdownMenuItem(
                value: product,
                child: new Text(product.name),
              );
            }).toList(),
          ),
        ),
      );
    },
  );

  final produceListLabel = new Center(
    child: Text(
    'Current Prices',
    style: TextStyle(color: Colors.green[700], fontSize: 22, fontFamily: 'Roboto'),
  ));

  final producePriceField = TextFormField(
    keyboardType: TextInputType.number,
    decoration: new InputDecoration(
      hintText: 'Produce price (${currentCurrency.symbol})',
      labelStyle: TextStyle(color: Colors.brown),
      labelText: 'Produce price (${currentCurrency.symbol})',
      icon: const Icon(Icons.date_range),
      contentPadding: EdgeInsets.all(15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    validator: (value) {
      if (value.isEmpty) {
        return 'Please enter produce price';
      }
    },
  );

  final newCashField = TextFormField(
    keyboardType: TextInputType.number,
    decoration: new InputDecoration(
      hintText: 'Add cash',
      labelStyle: TextStyle(color: Colors.brown),
      labelText: 'Add cash',
      icon: const Icon(Icons.attach_money),
      contentPadding: EdgeInsets.all(15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    validator: (value) {
      if (value.isEmpty) {
        return 'Please enter cash amount to add';
      }
    },
  );

  final languageField = new FormField(
    builder: (FormFieldState state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          icon: const Icon(Icons.library_books),
          // labelText: 'produce',
        ),
        isEmpty: _language == Language('-1', '-- Select language --', '--'),
        child: new DropdownButtonHideUnderline(
          child: new DropdownButton(
            value: _language,
            isDense: true,
            onChanged: (Language newLanguage) {
              setState(() {
                _language = newLanguage;
                inheritedWidget.setLanguage(newLanguage.code);
                state.didChange(newLanguage);
              });
            },
            items: _languages.map((Language language) {
              return new DropdownMenuItem(
                value: language,
                child: new Text(language.name),
              );
            }).toList(),
          ),
        ),
      );
    },
  );



final savePriceButton = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.lightBlueAccent.shade100,
      elevation: 5.0,
      color: Colors.greenAccent[700],
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => inheritedWidget.setLanguage(_language.code),
        child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
    ),
  );

  final currencyTab = Center(
    child: new Container(
      margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: boxHeight),
          new Text('Presently: ${currentCurrency.symbol}', style: TextStyle(fontSize: 15)),
          currencyField,
          SizedBox(height: boxHeight),
        ],
      ),
    )
  );

  final producePriceTab = SingleChildScrollView(
    child: new Container(
    margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        produceField,
        SizedBox(height: boxHeight),
        producePriceField,
        SizedBox(height: boxHeight),
        communityField,
        SizedBox(height: boxHeight),
        savePriceButton,
        SizedBox(height: boxHeight),
      ],
    ),
  )
);


  final languageTab = Center(
    child: new Container(
    margin: new EdgeInsets.only(left: 15.0, right: 15.0, top: 40.0, bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text('Presently: ${inheritedWidget.getLanguage()}', style: TextStyle(fontSize: 15),),
        languageField,
        SizedBox(height: boxHeight),
      ],
    ),
  )
);

  return DefaultTabController(
    length: 3,
    child: Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.language), text: labels[appLanguage]['language']),
            Tab(icon: Icon(Icons.monetization_on), text: labels[appLanguage]['currency']),
            Tab(icon: Icon(Icons.library_books), text: labels[appLanguage]['prices']),
          ],
        ),
        title: Text(displayName),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          children: [
            languageTab,
            currencyTab,
            producePriceTab,
          ],
        ),
      )
    ),
  );
  }
}
