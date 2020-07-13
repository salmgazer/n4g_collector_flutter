class Language {
  String name;
  String code;
  String id;

  Language(this.id, this.name, this.code);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Language && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  Language.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    name = map['name'];
    code = map['code'];
  }
  
  @override
  String toString() {
    return name;
  }

  static String tableName = 'languages';
}