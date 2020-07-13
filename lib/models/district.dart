class District {
  String id;
  String name;
  String regionId;
  int createdAt;
  int updatedAt;
  

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
    createdAt = int.parse(map['createdAt'].toString());
    updatedAt = int.parse(map['updatedAt'].toString());
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "name": name,
      "regionId": regionId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
    return map;
  }

  static String tableName = 'districts';
}
