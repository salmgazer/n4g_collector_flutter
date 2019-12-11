import 'package:flutter/material.dart';
import 'models/shipment.dart';
import './utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_state_container.dart';


class ShipmentPage extends StatelessWidget {
  static String tag = 'shipment-page';
  final Shipment shipment;

  const ShipmentPage(this.shipment);

  final boxHeight = 50.0;

  _launchCall(String number) async {
    var url = 'tel:$number';
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

  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();
    final displayName = labels[appLanguage]['shipment'];

    return new Scaffold(
        appBar: new AppBar(
            title: new Text(displayName , style: new TextStyle(color: Colors.white)),
            backgroundColor: Colors.brown[500],
            iconTheme: new IconThemeData(color: Colors.white)
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            ListTile(
              title: Text('Produce: ' + shipment.produce),
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text('Sacs: ' + shipment.sacs.toString()),
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text('Vehicle number: ' + shipment.vehicleNumber.toString()),
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text('Driver phone: ' + shipment.driverPhone),
            ),
            Divider(color: Colors.grey),
            ListTile(
              title: Text('Details : ' + shipment.note),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            Chip(
              backgroundColor: Colors.greenAccent,
              label: Text('Contact Driver'),
            ),
            SizedBox(height: 20),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RawMaterialButton(
                  onPressed: () async {
                    _launchCall(shipment.driverPhone);
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
                    _launchMessage(shipment.driverPhone);
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
              ],
            )
          ],
        )
    );
  }

}
