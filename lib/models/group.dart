class Group {
  String name;
  int id;
  DateTime createdAt;
  DateTime updatedAt;


  Group(this.id, this.name, this.createdAt, this.updatedAt);

  Group.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    this.createdAt = DateTime.parse(map['createdAt']);
    this.updatedAt = DateTime.parse(map['updatedAt']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Group && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }

  static String tableName = 'groups';
}
