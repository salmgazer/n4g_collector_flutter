import 'package:flutter/material.dart';
import '../models/shipment.dart';
import '../shipment-page.dart';


class ShipmentListItem extends ListTile {

  ShipmentListItem(Shipment shipment, BuildContext context) :
        super(
        contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 2.0),
        title : Text(shipment.sacs.toString() + ' sacs of ' + shipment.produce),
        subtitle: Text(shipment.vehicleNumber+ '  -  ' + shipment.date.toString(), style: TextStyle(fontSize: 12.0)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShipmentPage(shipment)));
        },
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
      );
}