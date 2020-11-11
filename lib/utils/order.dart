enum OrderType { Pickup, delivery }

class Order {
  final String locationName;
  final DateTime date;
  final OrderType type;
  final bool done;

  const Order({this.locationName, this.date, this.type, this.done});

  bool get isPickup => type == OrderType.Pickup;
}
