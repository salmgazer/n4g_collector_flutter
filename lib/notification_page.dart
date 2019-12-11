import 'package:flutter/material.dart';
import 'models/n4gnotification.dart';
import './utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_state_container.dart';


class NotificationPage extends StatelessWidget {
  static String tag = 'notification-page';
  final N4gNotification n4gnotification;

  _launchCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsapp(String number) async {
    var url = 'whatsapp://send?phone=$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMessage(String number) async {
    var url = 'sms:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  const NotificationPage(this.n4gnotification);

  final boxHeight = 50.0;

  @override
  Widget build(BuildContext context) {

    final pageLabel = new Center(
      child: Chip(
        label: Text('Contact ${n4gnotification.owner}'),
      )
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(n4gnotification.title , style: new TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[500],
        iconTheme: new IconThemeData(color: Colors.white)
      ),
      body: new ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          new ListTile(
            title: Text(n4gnotification.title),
          ),
          new Divider(color: Colors.grey),
          new ListTile(
            title: Text(n4gnotification.message),
          ),
          new Divider(color: Colors.grey),
          new ListTile(
            title: Text('Date: ' + n4gnotification.createdAt.toString()),
          ),
          new Divider(color: Colors.grey),
          SizedBox(height: 40),
          pageLabel,
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RawMaterialButton(
                onPressed: () async {
                  _launchCall(n4gnotification.ownerPhone);
                },
                child: new Icon(
                  Icons.phone,
                  color: Colors.blue,
                  size: 35.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
              ),
              new RawMaterialButton(
                onPressed: () async {
                  _launchMessage(n4gnotification.ownerPhone);
                },
                child: new Icon(
                  Icons.message,
                  color: Colors.white,
                  size: 35.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.blue,
                padding: const EdgeInsets.all(15.0),
              ),
              new RawMaterialButton(
                onPressed: () async {
                  _launchWhatsapp(n4gnotification.ownerPhone);
                },
                child: new IconButton(
                  onPressed: () async {
                    _launchWhatsapp(n4gnotification.ownerPhone);
                  },
                  iconSize: 80.0,
                  icon: new Image.asset("assets/whatsapp-96.png"),
                  color: Colors.white,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                padding: const EdgeInsets.all(7.0),
              )
            ],
          ),
        ],
      )
    );
  }

}
