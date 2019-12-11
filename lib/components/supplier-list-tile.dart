import 'package:flutter/material.dart';
import '../models/supplier.dart';
import '../supplier-page.dart';

class SupplierListItem extends ListTile {
  SupplierListItem(Supplier supplier, BuildContext context)
      : super(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: CircleAvatar(
              backgroundColor: Colors.brown[400],
              child: Text(supplier.firstName[0] + supplier.lastName[0],
                  style: TextStyle(color: Colors.white)),
            ),
            title: Text(
              '${supplier.firstName}   ${supplier.lastName}  (${supplier.membershipCode})',
              style: TextStyle(color: Colors.grey[800]),
            ),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.phone, color: Colors.brown),
                Text('  ${supplier.phone}  -  ${supplier.community}',
                    style: TextStyle(color: Colors.grey[700]))
              ],
            ),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.grey, size: 30.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupplierPage(supplier)));
            });
}

final supplierCard = (SupplierListItem tile) => Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: tile,
      ),
    );
