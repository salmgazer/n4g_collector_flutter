class Supplier {
  String firstName;
  String otherNames;
  String phone;
  String membershipCode;
  String gender;
  String about;
  String communityId;
  Supplier community;
  String organization;
  String organizationId;
  double accountBalance;
  int createdAt;
  int updatedAt;
  String id;

  Supplier(
    this.id,
    this.firstName,
    this.otherNames,
    this.phone,
    this.membershipCode,
    this.gender,
    this.about,
    this.communityId,
    this.organizationId,
    this.accountBalance,
    this.createdAt,
    this.updatedAt,
  );

  Supplier.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    firstName = map['firstName'];
    otherNames = map['otherNames'];
    phone = map['phone'];
    membershipCode = map['membershipCode'];
    gender = map['gender'];
    about = map['about'];
    communityId = map['communityId'];
    organizationId = map['organizationId'];
    accountBalance = map['accountBalance'];
    this.createdAt = int.parse(map['createdAt'].toString());
    this.updatedAt = int.parse(map['updatedAt'].toString());
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "firstName": firstName,
      "otherNames": otherNames,
      "phone": phone,
      "membershipCode": membershipCode,
      "gender": gender,
      "about": about,
      "communityId": communityId,
      "organizationId": organizationId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };

    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Supplier && runtimeType == other.runtimeType && firstName + " " + otherNames == other.firstName + " " + other.otherNames;

  @override
  int get hashCode => firstName.hashCode;

  @override
  String toString() {
    return firstName + " " + otherNames;
  }

  static String tableName = 'suppliers';
}
