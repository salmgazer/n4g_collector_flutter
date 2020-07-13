class User {
  String userId;
  String firstName;
  String otherNames;
  String phone;
  String status;
  String gender;
  String password;
  int createdAt;
  int updatedAt;

  User(
    this.userId,
    this.firstName,
    this.otherNames,
    this.phone,
    this.status,
    this.gender,
    this.password,
    this.createdAt,
    this.updatedAt,
  );

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        parsedJson['userId'],
        parsedJson['firstName'],
        parsedJson['otherNames'],
        parsedJson['phone'],
        parsedJson['status'],
        parsedJson['gender'],
        parsedJson['password'],
        int.parse(parsedJson['createdAt']),
        int.parse(parsedJson['updatedAt'])
    );
  }

  User.fromMap(Map<String, dynamic> map) {
    this.userId = map['userId'];
    firstName = map['firstName'];
    otherNames = map['otherNames'];
    phone = map['phone'];
    status = map['status'];
    gender = map['gender'];
    password = map['password'];
    this.createdAt = map['createdAt'];
    this.updatedAt = map['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "userId": userId.toString(),
      "firstName": firstName,
      "otherNames": otherNames,
      "phone": phone,
      "status": status,
      "password": password,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && firstName + " " + otherNames == other.firstName + " " + other.otherNames;

  @override
  int get hashCode => firstName.hashCode;
  
  @override
  String toString() {
    return firstName;
  }

  String get phoneNumber {
    return phone;
  }

  static String tableName = 'users';
}