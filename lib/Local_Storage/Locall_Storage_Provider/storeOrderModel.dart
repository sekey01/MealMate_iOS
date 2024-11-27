class StoreOrderLocally {
  final String id;
  final String item;
  final double price;
  final String time;

  StoreOrderLocally({required this.id, required this.item, required this.price, required this.time});

  Map<String, dynamic> toJson() => {
    'id': id,
    'item': item,
    'price': price,
    'time' : time,
  };

  factory StoreOrderLocally.fromJson(Map<String, dynamic> json) => StoreOrderLocally(
    id: json['id'],
    item: json['item'],
    price: json['price'],
    time : json['time'],
  );
}