import 'tag.dart';

class Cloth {
  final String id;
  final String orgId;
  final String? storageId;
  final String? photoUrl;
  final String? name;
  final List<Tag> tags;

  const Cloth({
    required this.id,
    required this.orgId,
    this.storageId,
    this.photoUrl,
    this.name,
    this.tags = const [],
  });

  factory Cloth.fromMap(Map<String, dynamic> map) => Cloth(
        id: map['id'] as String,
        orgId: map['org_id'] as String,
        storageId: map['storage_id'] as String?,
        photoUrl: map['photo_url'] as String?,
        name: map['name'] as String?,
        tags: (map['clothes_tags'] as List<dynamic>? ?? [])
            .map((t) => Tag.fromJoinMap(t as Map<String, dynamic>))
            .toList(),
      );
}
