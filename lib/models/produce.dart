class Produce {
  String name;
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  double unitPrice;

  Produce(this.id, this.name, this.unitPrice, this.createdAt, this.updatedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Produce && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
  @override
  String toString() {
    return name;
  }

  Produce.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    unitPrice = 50;
    this.createdAt = DateTime.parse(map['createdAt']);
    this.updatedAt = DateTime.parse(map['updatedAt']);
  }

  static String tableName = 'products';
}