class Country {
  int id;
  String name;
  String code;
  DateTime createdAt;
  DateTime updatedAt;


  Country(this.id, this.name, this.code, this.createdAt, this.updatedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
  @override
  String toString() {
    return name;
  }

  Country.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    code = map['code'];
    createdAt = DateTime.parse(map['createdAt']);
    updatedAt = DateTime.parse(map['updatedAt']);
  }

  factory Country.fromJson(Map<String, dynamic> parsedJson) {
    return Country(
      parsedJson['id'],
      parsedJson['name'],
      parsedJson['code'],
      parsedJson['createdAt'],
      parsedJson['updatedAt']
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "name": name,
      "code": code,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  static String tableName = 'countries';
}
