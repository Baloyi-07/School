class TodoEntry {
  Map<dynamic, dynamic> todos;
  Map<dynamic, dynamic> notes;
  Map<dynamic, dynamic> items;
  String username;
  String? objectId;
  DateTime? created;
  DateTime? updated;

  TodoEntry({
    required this.todos,
    required this.items,
    required this.notes,
    required this.username,
    this.objectId,
    this.created,
    this.updated,
  });

  Map<String, Object?> toJson() => {
        'username': username,
        'todos': todos,
        'notes': notes,
        'items': items,
        'created': created,
        'updated': updated,
        'objectId': objectId,
      };

  static TodoEntry fromJson(Map<dynamic, dynamic>? json) => TodoEntry(
        username: json!['username'] as String,
        todos: json['todos'] as Map<dynamic, dynamic>,
        notes: json['notes'] as Map<dynamic, dynamic>,
        items: json['items'] as Map<dynamic, dynamic>,
        objectId: json['objectId'] as String,
        created: json['created'] as DateTime,
      );
}
