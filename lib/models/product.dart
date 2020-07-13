class Product {
  String name;
  String id;
  int createdAt;
  int updatedAt;
  double unitPrice;

  Product(this.id, this.name, this.unitPrice, this.createdAt, this.updatedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
  @override
  String toString() {
    return name;
  }

  Product.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    unitPrice = 50;
    this.createdAt = map['createdAt'];
    this.updatedAt = map['updatedAt'];
  }

  static String tableName = 'products';
}