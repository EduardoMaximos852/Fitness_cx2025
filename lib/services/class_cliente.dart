class Client {
  final int? id;
  final String name;
  final String level;
  final int progress;

  Client({
    this.id,
    required this.name,
    required this.level,
    required this.progress,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'level': level, 'progress': progress};
  }
}
