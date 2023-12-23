class Item {
  final int id;
  final String title;
  bool _done; // Adição aqui

  Item({
    required this.id,
    required this.title,
    required bool done,
  }) : _done = done;

  bool get done => _done;

  set done(bool value) {
    _done = value;
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      title: map['title'] as String,
      done: map['done'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'done': done ? 1 : 0,
    };
  }
}
