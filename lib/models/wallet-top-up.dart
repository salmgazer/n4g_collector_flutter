class WalletTopUp {
  int id;
  double amount;
  int byUserId;
  int forUserId;
  String byUser;
  String forUser;
  DateTime createdAt;
  DateTime updatedAt;

  WalletTopUp(
      this.id,
      this.amount,
      this.byUser,
      this.byUserId,
      this.forUser,
      this.forUserId,
      this.createdAt,
      this.updatedAt
      );

  WalletTopUp.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    amount = double.parse(map['amount'].toString());
    forUser = map['forUser'];
    byUser = map['byUserFirstName'] + ' ' + map['byUserLastName'] ;
    byUserId = map['byUserId'];
    forUserId = map['forUserId'];
    this.createdAt = DateTime.parse(map['createdAt']);
    this.updatedAt = DateTime.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "amount": amount,
      "forUserId": forUserId,
      "byuserId": byUserId,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WalletTopUp && runtimeType == other.runtimeType && forUser + " " + forUser+ " " + createdAt.toString() == other.forUser + " " + other.forUser + " " + other.createdAt.toString();

  @override
  int get hashCode => byUser.hashCode;

  @override
  String toString() {
    return amount.toString() + " " + createdAt.toString()+ " ";
  }

  static String tableName = 'walletTopUps';
}