class Community {
  String name;
  int id;
  DateTime createdAt;
  DateTime updatedAt;

  Community(this.id, this.name, this.createdAt, this.updatedAt);

  Community.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    createdAt = DateTime.parse(map['createdAt']);
    updatedAt = DateTime.parse(map['updatedAt']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Community && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
  @override
  String toString() {
    return name;
  }

  static String tableName = 'communities';
}
