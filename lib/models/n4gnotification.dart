class N4gNotification {
  final int id;
  final String type;
  final String title;
  final String message;
  final String owner;
  final String ownerPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const N4gNotification(this.id, this.type, this.title, this.message, this.owner, this.ownerPhone, this.createdAt, this.updatedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is N4gNotification && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
  
  @override
  String toString() {
    return message;
  }
}