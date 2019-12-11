class Withdrawal {
  int id;
  double amount;
  String collector;
  String supplier;
  String reason;
  int productId;
  int sacs;
  String produce;
  DateTime createdAt;
  DateTime updatedAt;

  Withdrawal(
    this.id,
    this.amount,
    this.collector,
    this.supplier,
    this.reason,
    this.productId,
    this.sacs,
    this.produce,
    this.createdAt,
    this.updatedAt
  );

  Withdrawal.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    amount = double.parse(map['amount'].toString());
    collector = map['collectorFirstName'] + map['collectorLastName'];
    supplier = map['supplier'];
    reason = map['reason'];
    productId = map['productId'];
    sacs = map['sacs'];
    produce = map['produce'];
    this.createdAt = DateTime.parse(map['createdAt']);
    this.updatedAt = DateTime.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "amount": amount,
      "reason": reason,
      "collector": collector,
      "supplier": supplier,
      "productId": productId,
      "sacs": sacs,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Withdrawal && runtimeType == other.runtimeType && supplier + " " + supplier + " " + createdAt.toString() == other.supplier + " " + other.supplier + " " + other.createdAt.toString();

  @override
  int get hashCode => supplier.hashCode;

  @override
  String toString() {
    return supplier + " " + amount.toString() + " ";
  }

  static String tableName = 'withdrawals';
}