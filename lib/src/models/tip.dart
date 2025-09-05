class Tip {
  final String id;
  final String category;
  final String title;
  final String body;
  final List<String> tags;

  Tip({required this.id, required this.category, required this.title, required this.body, required this.tags});

  factory Tip.fromMap(Map<String, dynamic> m) => Tip(
    id: m['id'] ?? '',
    category: m['category'] ?? 'Général',
    title: m['title'] ?? '',
    body: m['body'] ?? '',
    tags: (m['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
    'title': title,
    'body': body,
    'tags': tags,
  };
}
