class Shipment {
  final int id;
  final int sacs;
  final String vehicleNumber;
  final String produce;
  final String driverPhone;
  final String note;
  final DateTime date;

  const Shipment(this.id, this.sacs, this.vehicleNumber, this.produce, this.driverPhone, this.note, this.date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Shipment && runtimeType == other.runtimeType && note == other.note;

  @override
  int get hashCode => note.hashCode;

  @override
  String toString() {
    return note;
  }

  static String tableName () => 'shipments';
}
