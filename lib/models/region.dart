class Region {
  int id;
  String name;
  int countryId;
  DateTime createdAt;
  DateTime updatedAt;

  Region(this.id, this.name, this.createdAt, this.updatedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Region && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
  @override
  String toString() {
    return name;
  }

  Region.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    countryId = map['countryId'];
    createdAt = DateTime.parse(map['createdAt']);
    updatedAt = DateTime.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "name": name,
      "countryId": countryId,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  static String tableName = 'regions';
}
