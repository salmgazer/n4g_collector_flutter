import 'package:collector/wallet-page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'settings_page.dart';
import 'download_sites_page.dart';
import 'profile-page.dart';
import 'suppliers-page.dart';
import 'shipments-page.dart';
import 'app_state_container.dart';

void main() => runApp( new AppStateContainer(
  child: MyApp()
));

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => new LoginPage(),
    DashboardPage.tag: (context) => new DashboardPage(),
    WalletPage.tag: (context) => new WalletPage(),
    ShipmentsPage.tag: (context) => new ShipmentsPage(),
    SettingsPage.tag: (context) => new SettingsPage(),
    DownloadSitesPage.tag: (context) => new DownloadSitesPage(),
    ProfilePage.tag: (context) => new ProfilePage(),
    SuppliersPage.tag: (context) => new SuppliersPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N4G Collector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}