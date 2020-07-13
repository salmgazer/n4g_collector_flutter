import 'package:flutter/material.dart';
import 'utils/strings.dart';
import 'models/shipment.dart';
import 'components/shipment-list-item.dart';
import 'components/my-drawer.dart';
import 'app_state_container.dart';

import 'models/product.dart';

// Create a Form Widget
class ShipmentsPage extends StatefulWidget {
  static String tag = 'shipments-page';

  @override
  _ShipmentsPageState createState() {
    return _ShipmentsPageState();
  }
}

class _ShipmentsPageState extends State<ShipmentsPage> {

  final boxHeight = 50.0;


  List<Shipment> getShipments() {
    return <Shipment>[
      Shipment(1, 30, "GT 345-15", "Shea nuts", "0545566400", "The weather is bad so he may arrive late", DateTime(2019)),
      Shipment(2, 50, "GT 367-15", "Shea nuts", "0545566499", "The weather is bad so he may arrive late", DateTime(2019)),
      Shipment(3, 80, "GT 145-15", "Shea nuts", "0245566400", "The weather is bad so he may arrive late", DateTime(2019)),
      Shipment(4, 50, "GT 45-16", "Shea nuts", "0244566400", "The weather is bad so he may arrive late", DateTime(2019)),
    ];
  }

  List<ShipmentListItem> _buildShipmentList(BuildContext context) {
    return this.getShipments().map((shipment) => ShipmentListItem(shipment, context)).toList();
  }


  double walletCash = 8000;

  static final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  Product _product = Product('-1', '-- Select product --', 0, currentTime, currentTime);
  List<Product> _products = <Product>[];


  @override
  Widget build(BuildContext context) {
    final AppStateContainerState inheritedWidget = AppStateContainer.of(context);
    final appLanguage = inheritedWidget.getLanguage();

    final productField = new FormField(
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.nature),
            labelText: 'Select Product',
          ),
          isEmpty: _product == Product('-1', '-- Select product --', 0, currentTime, currentTime),
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _product,
              isDense: true,
              onChanged: (Product newProduct) {
                setState(() {
                  _product = newProduct;
                  state.didChange(newProduct);
                });
              },
              items: _products.map((Product product) {
                return new DropdownMenuItem(
                  value: product,
                  child: new Text(product.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final shipmentsTab = new Center(
      child: ListView(
          padding: EdgeInsets.symmetric(vertical: 2.0),
          children: _buildShipmentList(context)
      ),
    );

    final saveButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        color: Colors.greenAccent[700],
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
          },
          child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        ),
      ),
    );

    final newShipmentTab = new Container(
      margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 30),
      child: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
              productField,
              SizedBox(height: 20),
              new TextFormField(
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  hintText: 'Number of sacs',
                  labelStyle: TextStyle(color: Colors.brown),
                  labelText: 'Number of sacs',
                  icon: const Icon(Icons.shopping_cart),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter number of sacs';
                  }
                },
              ),
              SizedBox(height: 20),
              new TextFormField(
                decoration: new InputDecoration(
                  hintText: 'Vehicle number',
                  labelStyle: TextStyle(color: Colors.brown),
                  labelText: 'Vehicle number',
                  icon: const Icon(Icons.insert_drive_file),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter number plate';
                  }
                },
              ),
              SizedBox(height: 20),
              new TextFormField(
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  hintText: 'Driver phone number',
                  labelStyle: TextStyle(color: Colors.brown),
                  labelText: 'Driver phone number',
                  icon: const Icon(Icons.phone),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter driver phone number';
                  }
                },
              ),
              SizedBox(height: 20),
              new TextFormField(
                decoration: new InputDecoration(
                  hintText: 'Departing from',
                  labelStyle: TextStyle(color: Colors.brown),
                  labelText: 'Departing from',
                  icon: const Icon(Icons.location_on),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter departure location';
                  }
                },
              ),
              SizedBox(height: 20),
              new TextFormField(
                decoration: new InputDecoration(
                  hintText: 'Destination / Warehouse',
                  labelStyle: TextStyle(color: Colors.brown),
                  labelText: 'Destination /Warehouse',
                  icon: const Icon(Icons.location_on),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter destination';
                  }
                },
              ),
              SizedBox(height: 20),
              new TextFormField(
                maxLines: 3,
                decoration: new InputDecoration(
                  hintText: 'Details of shipment',
                  labelStyle: TextStyle(color: Colors.brown),
                  labelText: 'Details of shipment (optional)',
                  icon: const Icon(Icons.message),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter driver phone number';
                  }
                },
              ),
              SizedBox(height: 20),
              saveButton,
            ],
        ),
      ),
    );


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MyDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.add),
                    text: labels[appLanguage]['new_shipment']),
                Tab(icon: Icon(Icons.local_shipping),
                    text: labels[appLanguage]['shipments'])
              ],
            ),
            title: Text("Shipments"),
          ),
          body: Form(
            child: TabBarView(
              children: [
                newShipmentTab,
                shipmentsTab,
              ],
            ),
          )
      ),
    );
  }

}
