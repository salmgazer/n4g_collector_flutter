class Community {
  String name;
  String id;
  int createdAt;
  int updatedAt;

  Community(this.id, this.name, this.createdAt, this.updatedAt);

  Community.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    createdAt = int.parse(map['createdAt'].toString());
    updatedAt = int.parse(map['updatedAt'].toString());
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
