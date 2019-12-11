import 'package:flutter/material.dart';
import '../models/n4gnotification.dart';
import '../notification_page.dart';


class NotificationListItem extends ListTile {

  NotificationListItem(N4gNotification notification, BuildContext context) :
    super(
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
      title : Text(notification.title),
      subtitle: Text(notification.createdAt.toString(), style: TextStyle(fontSize: 12.0)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(notification)));
      },
      trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
      leading: CircleAvatar(
        backgroundColor: Colors.white30,
        child: Icon(notification.type == 'price' ? Icons.monetization_on : Icons.local_shipping,
            color: notification.type == 'price' ? Colors.lightGreen : Colors.brown, size: 20),
        ),
    );
}
