class Tag {
  final String id;
  final String name;
  final String category;
  final bool aiGenerated;

  const Tag({
    required this.id,
    required this.name,
    required this.category,
    this.aiGenerated = false,
  });

  factory Tag.fromJoinMap(Map<String, dynamic> map) => Tag(
        id: (map['tags'] as Map<String, dynamic>)['id'] as String,
        name: (map['tags'] as Map<String, dynamic>)['name'] as String,
        category: (map['tags'] as Map<String, dynamic>)['category'] as String,
        aiGenerated: map['ai_generated'] as bool? ?? false,
      );
}
