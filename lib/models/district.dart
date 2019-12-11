class District {
  int id;
  String name;
  int regionId;
  DateTime createdAt;
  DateTime updatedAt;
  

  District(this.id, this.name, this.regionId, this.createdAt, this.updatedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is District && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
  @override
  String toString() {
    return name;
  }

  District.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    regionId = map['regionId'];
    createdAt = DateTime.parse(map['createdAt']);
    updatedAt = DateTime.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "name": name,
      "regionId": regionId,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  static String tableName = 'districts';
}
