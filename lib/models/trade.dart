import 'dart:math';

class Trade {
  String id;
  String date;
  String payment;
  double cost;
  double amountPaid;
  String produce;
  String supplier;
  String collectorId;
  String collector;
  String currencyId;
  double sacs; // make int
  String yield; // in kg, make double
  String otherCostPurpose;
  String otherCost; // make double
  String produceId;
  int createdAt;
  int updatedAt;

  Trade(
    this.id,
    this.date,
    this.payment,
    this.cost,
    this.amountPaid,
    this.produce,
    this.supplier,
    this.collectorId,
    this.currencyId,
    this.sacs,
    this.yield,
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
    currencyId = map['currencyId'];
    sacs = map['sacs'];
    yield = map['yield'].toString();
    otherCost =  map['otherCost'].toString();
    otherCostPurpose = map['otherCostPurpose'];
    this.createdAt = int.parse(map['createdAt'].toString());
    this.updatedAt = int.parse(map['updatedAt'].toString());
  }


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id,
      "date": date,
      "payment": payment,
      "cost": cost,
      "amountPaid": amountPaid,
      "productId": produce,
      "collectorId": collectorId,
      "currencyId": currencyId,
      "sacs": sacs,
      "yield": yield,
      "otherCost": otherCost,
      "otherCostPurpose": otherCostPurpose,
      "createdAt": createdAt,
      "updatedAt": updatedAt
    };
    return map;
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