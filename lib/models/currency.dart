class Currency {
  int id;
  String name;
  String symbol;

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
  }

  static String tableName = 'currencies';
}