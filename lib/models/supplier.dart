class Supplier {
  String firstName;
  String lastName;
  String phone;
  String membershipCode;
  String gender;
  String about;
  String district;
  String community;
  String group;
  double accountBalance;
  DateTime createdAt;
  DateTime updatedAt;
  int id;

  Supplier(
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.membershipCode,
    this.gender,
    this.about,
    this.district,
    this.community,
    this.group,
    this.accountBalance,
    this.createdAt,
    this.updatedAt,
  );

  Supplier.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    phone = map['phone'];
    membershipCode = map['membershipCode'];
    gender = map['gender'];
    about = map['about'];
    district = map['district'];
    community = map['community'];
    group = map['group'];
    accountBalance = map['accountBalance'];
    this.createdAt = DateTime.parse(map['createdAt']);
    this.updatedAt = DateTime.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "membershipCode": membershipCode,
      "gender": gender,
      "about": about,
      "district": district,
      "community": community,
      "group": group,
      "accountBalance": accountBalance,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Supplier && runtimeType == other.runtimeType && firstName + " " + lastName == other.firstName + " " + other.lastName;

  @override
  int get hashCode => firstName.hashCode;

  @override
  String toString() {
    return firstName + " " + lastName;
  }

  static String tableName = 'suppliers';
}
