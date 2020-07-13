class Organization {
  String name;
  String id;
  String communityId;
  int createdAt;
  int updatedAt;


  Organization(this.id, this.name, this.communityId, this.createdAt, this.updatedAt);

  Organization.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    communityId = map['communityId'];
    this.createdAt = int.parse(map['createdAt'].toString());
    this.updatedAt = int.parse(map['updatedAt'].toString());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Organization && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }

  static String tableName = 'organizations';
}
