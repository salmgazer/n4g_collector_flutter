import 'package:collector/sync-page.dart';
import 'package:collector/wallet-page.dart';
import 'package:flutter/material.dart';
import '../dashboard_page.dart';
import '../settings_page.dart';
import '../download_sites_page.dart';
import '../profile-page.dart';
import '../suppliers-page.dart';
import '../login_page.dart';
import '../utils/strings.dart';
import '../shipments-page.dart';
import '../app_state_container.dart';
import '../wallet-page.dart';
import '../sync-page.dart';

class MyDrawer extends StatelessWidget {
  static final drawerHeaderTextStyleName = new TextStyle(color: Colors.white, fontSize: 20);
  static final drawerHeaderTextStylePhone = new TextStyle(color: Colors.white);


  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final user = inheritedWidget.getUser();
    final appLanguage = inheritedWidget.getLanguage();
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.toString(), style: drawerHeaderTextStyleName),
              accountEmail: Text(user.phone, style: drawerHeaderTextStylePhone),
              decoration: BoxDecoration(color: Colors.brown),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(labels[appLanguage]['dashboard']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(DashboardPage.tag);
              },
            ),
            Divider(
              height: 2.0,
            ),
            /*
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text(labels[appLanguage]['wallet']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(WalletPage.tag);
              },
            ),
            Divider(
              height: 2.0,
            ),
             */
            ListTile(
              leading: Icon(Icons.people),
              title: Text(labels[appLanguage]['suppliers']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SuppliersPage.tag);
              },
            ),
            /*
            Divider(
              height: 2.0,
            ),
            ListTile(
              leading: Icon(Icons.local_shipping),
              title: Text(labels[appLanguage]['shipments']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ShipmentsPage.tag);
              },
            ),
            */
            Divider(
              height: 2.0,
            ),
             ListTile(
              leading: Icon(Icons.cloud_download),
              title: Text(labels[appLanguage]['download_sites']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(DownloadSitesPage.tag);
              },
            ),

            Divider(
              height: 2.0,
            ),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text(labels[appLanguage]['sync']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SyncPage.tag);
              },
            ),
            Divider(
              height: 2.0,
            ),
            /*
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(labels[appLanguage]['settings']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SettingsPage.tag);
              },
            ),
            Divider(
              height: 2.0,
            ),
            */
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(labels[appLanguage]['profile']),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ProfilePage.tag);
              },
            ),
            Divider(
              height: 2.0,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(labels[appLanguage]['sign_out']),
              onTap: () {
                inheritedWidget.removeUser();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LoginPage.tag);
              },
            ),
            Divider(
              height: 2.0,
            ),
          ],
        ),
      );
    }
  }
