class Currency {
  String id;
  String name;
  String symbol;
  int createdAt;
  int updatedAt;

  Currency(this.id, this.name, this.symbol);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Currency && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
  @override
  String toString() {
    return name;
  }

  Currency.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    symbol = map['symbol'];
    createdAt = int.parse(map['createdAt']);
    updatedAt = int.parse(map['updatedAt']);
  }

  static String tableName = 'currencies';
}