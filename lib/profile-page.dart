import 'package:flutter/material.dart';
import 'components/my-drawer.dart';
import './utils/strings.dart';
import 'app_state_container.dart';


class ProfilePage extends StatelessWidget {
  static String tag = 'profile-page';

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final user = inheritedWidget.getUser();
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['profile'];

    return new Scaffold(
      drawer: MyDrawer(),
      appBar: new AppBar(
        title: new Text(displayName, style: new TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[500],
        iconTheme: new IconThemeData(color: Colors.white)
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('${labels[appLanguage]['first_name']}: ${user.firstName}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('${labels[appLanguage]['last_name']}: ${user.otherNames}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(user.phone),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('${labels[appLanguage]['since']}: ${user.createdAt}'),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('${labels[appLanguage]['last_updated']}: ${user.updatedAt}'),
          ),
          Divider(color: Colors.grey),
        ],
      )
    );
  }
}
