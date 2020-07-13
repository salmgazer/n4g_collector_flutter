class Country {
  String name;
  String code;
  int createdAt;
  int updatedAt;


  Country(this.name, this.code, this.createdAt, this.updatedAt);

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
    name = map['name'];
    code = map['code'];
    createdAt = int.parse(map['createdAt'].toString());
    updatedAt = int.parse(map['updatedAt'].toString());
  }

  factory Country.fromJson(Map<String, dynamic> parsedJson) {
    return Country(
      parsedJson['name'],
      parsedJson['code'],
      int.parse(parsedJson['createdAt']),
      int.parse(parsedJson['updatedAt'])
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "name": name,
      "code": code,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
    return map;
  }

  static String tableName = 'countries';
}
