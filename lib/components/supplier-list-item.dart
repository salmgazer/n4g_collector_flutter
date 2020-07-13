import 'package:flutter/material.dart';
import '../models/supplier.dart';
import '../supplier-page.dart';


class SupplierListItem extends ListTile {

  SupplierListItem(Supplier supplier, BuildContext context) :
    super(
      title : Text(supplier.toString() + '   (' + supplier.membershipCode + ')'),
      subtitle: Text(supplier.communityId + '    ' + supplier.phone),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierPage(supplier)));
      },
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(supplier.firstName[0] + supplier.otherNames[0], style: TextStyle(color: Colors.white)),
      ),
      trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
    );
}
