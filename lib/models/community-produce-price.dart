class CommunityProducePrice {
  int id;
  double price;
  int communityId;
  int produceId;
  int userId;
  String community;
  String produce;
  String byUser;
  int createdAt;
  int updatedAt;

  CommunityProducePrice(
    this.id,
    this.price,
    this.communityId,
    this.produceId,
    this.userId,
    this.community,
    this.produce,
    this.byUser,
    this.createdAt,
    this.updatedAt
  );

  CommunityProducePrice.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    price = map['price'];
    communityId = map['communityId'];
    produceId = map['produceId'];
    userId = map['userId'];
    community = map['community'];
    produce = map['produce'];
    byUser = map['byUser'];
    this.createdAt = int.parse(map['createdAt']);
    this.updatedAt = int.parse(map['updatedAt']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "id": id.toString(),
      "price": price,
      "communityId": communityId,
      "produceId": produceId,
      "userId": userId,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CommunityProducePrice && runtimeType == other.runtimeType && price.toString() + " " + createdAt.toString() == other.price.toString() + " " + other.price.toString()+ " " + other.createdAt.toString();

  @override
  int get hashCode => byUser.hashCode;

  @override
  String toString() {
    return price.toString() + " " + createdAt.toString()+ " ";
  }

  static String tableName = 'communityProducePrices';
}