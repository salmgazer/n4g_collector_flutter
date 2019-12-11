import 'dart:math';

class Trade {
  int id;
  String date;
  String payment;
  double cost;
  double amountPaid;
  String produce;
  String supplier;
  int collectorId;
  String collector;
  String currency;
  int sacs; // make int
  String produceYield; // in kg, make double
  String otherCostPurpose;
  String otherCost; // make double
  int produceId;
  DateTime createdAt;
  DateTime updatedAt;

  Trade(
    this.id,
    this.date,
    this.payment,
    this.cost,
    this.amountPaid,
    this.produce,
    this.supplier,
    this.collectorId,
    this.collector,
    this.currency,
    this.sacs,
    this.produceYield,
    this.otherCost,
    this.otherCostPurpose,
    this.createdAt,
    this.updatedAt,
  );

  Trade.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    date = map['date'];
    payment = map['payment'];
    cost = map['cost'];
    amountPaid = map['amountPaid'];
    produce = map['produce'];
    produceId = map['productId'];
    supplier = map['supplierFirstName'];
    collectorId = map['collectorId'];
    collector = map['collectorFirstName'] + " " + map['collectorLastName'];
    currency = map['currency'];
    sacs = map['sacs'];
    produceYield = map['yield'].toString();
    otherCost =  map['otherCost'].toString();
    otherCostPurpose = map['otherCostPurpose'];
    this.createdAt = DateTime.parse(map['createdAt']);
    this.updatedAt = DateTime.parse(map['updatedAt']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trade && runtimeType == other.runtimeType && supplier + " " + produce + " " + date.toString() == other.supplier + " " + other.produce + " " + other.date.toString();

  @override
  int get hashCode => supplier.hashCode;
  
  @override
  String toString() {
    return " " + produce + " " + date.toString();
  }

  static String tableName = 'transactions';
}