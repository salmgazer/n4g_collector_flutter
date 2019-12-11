import 'package:collector/middleware/Api.dart';
import 'package:collector/models/app_settings.dart';
import 'package:collector/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'models/community.dart';
import 'models/produce.dart';
import 'middleware/AppDb.dart';
import 'models/currency.dart';
import 'dart:convert';


// Inherited Widget
class AppStateContainer extends StatefulWidget {
  // Your apps state is managed by the container
  // final AppState state;
  // This widget is simply the root of the tree,
  // so it has to have a child!
  final Widget child;

  AppStateContainer({
    @required this.child,
    // this.state,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedStateContainer)
    as InheritedStateContainer)
        .data;
  }

  @override
  AppStateContainerState createState() => new AppStateContainerState();
}

// Inherited Widget state
class AppStateContainerState extends State<AppStateContainer> {
  // Just padding the state through so we don't have to
  // manipulate it with widget.state.
  // AppState state;

  User user;
  String language;
  Currency currency;
  List<Community> communities;
  List<Group> groups;
  List<Produce> products;
  AppSetting appSetting;

  @override
  void initState() {
    // You'll almost certainly want to do some logic
    // in InitState of your AppStateContainer. In this example, we'll eventually
    // write the methods to check the local state
    // for existing users and all that.

    getAppSettingFromDB().then((fetchedAppSetting) => setState(() {
      setAppSetting(fetchedAppSetting);

      getUsersFromDB().then((fetchedUsersFromDB) => setState(() {
        if (fetchedUsersFromDB.length < 1) {
          print("About to fetch users from API");
          getUsersFromApi().then((fetchedUsersFromApi) => setState(() {
            print(fetchedUsersFromApi);
            for (var i = 0; i < fetchedUsersFromApi['data'].length; i++) {
              AppDb.createOne('users', fetchedUsersFromApi['data'][i]);
            }
          }));
        } else {
          print("There are users in local db");
          print(fetchedUsersFromDB);
        }
      }));

      getProductsFromDB().then((fetchedProductsFromDB) => setState(() {
        if (fetchedProductsFromDB.length < 1) {
          print("About to fetch products from API");
          getProductsFromApi().then((fetchedProductsFromApi) => setState(() {
            AppDb.batchInsert(Produce.tableName, fetchedProductsFromApi['data']);
          }));
        }
      }));

      /*
      getProductsFromDB().then((fetchedProducts) => setState(() {
        setProducts(fetchedProducts);
        getCommunitiesFromDB().then((fetchedCommunities) => setState(() {
          setCommunities(fetchedCommunities);
          getGroupsFromDB().then((fetchedGroups) => setState(() {
            setGroups(fetchedGroups);
          }));
        }));
      }));

      */

    }));
    
    super.initState();
  }

  User getUser() => this.user;

  updateUser(userId) {
    AppDb.findUserById(userId).then((nUser) => setState(() {
      saveUser(nUser);
    }));
  }

  String getLanguage() => this.language;

  Currency getCurrency() => this.currency == null ? new Currency(1, 'Ghanaian cedis', 'GH₵') : this.currency;

  List<Community> getCommunities() => this.communities;

  List<Group> getGroups() => this.groups;

  List<Produce> getProducts() => this.products;

  AppSetting getAppSetting() => this.appSetting;

  getProductsFromDB() async {
    return AppDb.filterProducts();
  }

  getUsersFromDB() async {
    return AppDb.filterUsers();
  }

  getCommunitiesFromDB() async {
    return AppDb.filterCommunities();
  }

  getGroupsFromDB() async {
    return AppDb.filterGroups();
  }

  getAppSettingFromDB() async {
    return AppDb.getAppSetting();
  }

  getUsersFromApi() async {
    final queryString = new Map<String, String>();
    queryString['roles'] = 'collector';
    final response = await Api().filter(User.tableName, queryString);
    return json.decode(response.body);
  }

  getProductsFromApi() async {
    final queryString = new Map<String, String>();
    final response = await Api().filter(Produce.tableName, queryString);
    return json.decode(response.body);
  }

  getCountryFromApi(id) async {
    final queryString = new Map<String, String>();
    final response = await Api().findOne(Country.tableName, id, queryString);
    return json.decode(response.body);
  }

  void setAppSetting(AppSetting appSetting) {
    // print(appSetting.languageName);
    setState(() {
      this.appSetting = appSetting;
    });
  }

  void setProducts(List<Produce> products) {
    setState(() {
      this.products = products;
    });
  }

  void setCommunities(List<Community> communities) {
    setState(() {
      this.communities = communities;
    });
  }

  void setGroups(List<Group> groups) {
    setState(() {
      this.groups = groups;
    });
  }

  void setLanguage(String lang) {
    setState(() {
      this.language = lang;
    });
  }

  void setCurrency(Currency currency) {
    setState(() {
      this.currency = currency;
    });
  }

  void saveUser(User user) {
    setState(() {
      this.user = user;
    });
  }

  void removeUser() {
    setState(() {
      this.user = null;
    });
  }

  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class InheritedStateContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final AppStateContainerState data;

  // InheritedWidgets are always just wrappers.
  // So there has to be a child,
  // Although Flutter just knows to build the Widget thats passed to it
  // So you don't have have a build method or anything.
  InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a better way to do this, which you'll see later.
  // But basically, Flutter automatically calls this method when any data
  // in this widget is changed.
  // You can use this method to make sure that flutter actually should
  // repaint the tree, or do nothing.
  // It helps with performance.
  @override
  bool updateShouldNotify(InheritedStateContainer old) => true;
}
