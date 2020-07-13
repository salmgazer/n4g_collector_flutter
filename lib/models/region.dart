class Region {
  String id;
  String name;
  String countryCode;
  int createdAt;
  int updatedAt;

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
    countryCode = map['countryCode'];
    createdAt = int.parse(map['createdAt'].toString());
    updatedAt = int.parse(map['updatedAt'].toString());
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "name": name,
      "countryCode": countryCode,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
    return map;
  }

  static String tableName = 'regions';
}
