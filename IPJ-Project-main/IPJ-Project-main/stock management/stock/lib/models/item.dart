Map<dynamic, dynamic> convertItemListToMap(List<Item> items) {
  Map<dynamic, dynamic> map = {};
  for (var i = 0; i < items.length; i++) {
    map.addAll({'$i': items[i].toJson()});
  }
  return map;
}

List<Item> convertMapToItemList(Map<dynamic, dynamic> map) {
  List<Item> items = [];
  for (var i = 0; i < map.length; i++) {
    items.add(Item.fromJson(map['$i']));
  }
  return items;
}

class Item {
  late final String title;
  late final String item;
  late final String price;
  bool done;
  final DateTime created;

  Item({
    required this.title,
    required this.item,
    required this.price,
    this.done = false,
    required this.created,
  });

  Map<String, Object?> toJson() => {
        'title': title,
        'item': item,
        'price': price,
        'done': done ? 1 : 0,
        'created': created.millisecondsSinceEpoch,
      };

  static Item fromJson(Map<dynamic, dynamic>? json) => Item(
        title: json!['title'] as String,
        item: json['item'] as String,
        price: json['price'] as String,
        done: json['done'] == 1 ? true : false,
        created: DateTime.fromMillisecondsSinceEpoch(
            (json['created'] as double).toInt()),
      );

  @override
  bool operator ==(covariant Item item) {
    return (this.title.toUpperCase().compareTo(item.title.toUpperCase()) == 0 &&
        this.price.toUpperCase().compareTo(item.price.toUpperCase()) == 0 &&
        this.item.toUpperCase().compareTo(item.item.toUpperCase()) == 0);
  }

  @override
  int get hashCode {
    return title.hashCode;
  }
}
