class User {
  int id;
  String firstName;
  String lastName;
  String otherNames;
  String email;
  String phone;
  String country;
  String roles;
  String status;
  String community;
  int countryId;
  bool confirmed;
  double wallet;
  DateTime createdAt;
  DateTime updatedAt;

  User(
    this.id,
    this.firstName,
    this.lastName,
    this.otherNames,
    this.email,
    this.phone,
    this.country,
    this.roles,
    this.status,
    this.community,
    this.confirmed,
    this.wallet,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  );

  User.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    otherNames = map['otherNames'];
    email = map['email'];
    phone = map['phone'];
    countryId = map['countryId'];
    country = map['country'];
    roles = map['roles'];
    status = map['status'];
    community = map['community'];
    confirmed = (map['confirmed'] == 'false' ? false : true);
    wallet = map['wallet'];
    this.createdAt = DateTime.parse(map['createdAt']);
    this.updatedAt = DateTime.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "firstName": firstName,
      "lastName": lastName,
      "otherNames": otherNames,
      "email": email,
      "phone": phone,
      "countryId": countryId,
      "roles": roles,
      "status": status,
      "confirmed": confirmed,
      "wallet": wallet,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && firstName + " " + lastName == other.firstName + " " + other.lastName;

  @override
  int get hashCode => firstName.hashCode;
  
  @override
  String toString() {
    return firstName + " " + lastName;
  }

  String get phoneNumber {
    return phone;
  }

  static String tableName = 'users';
}