class Location {
  final String id;
  final String orgId;
  final String name;
  final int sortOrder;

  const Location({
    required this.id,
    required this.orgId,
    required this.name,
    this.sortOrder = 0,
  });

  factory Location.fromMap(Map<String, dynamic> map) => Location(
        id: map['id'] as String,
        orgId: map['org_id'] as String,
        name: map['name'] as String,
        sortOrder: map['sort_order'] as int? ?? 0,
      );
}
