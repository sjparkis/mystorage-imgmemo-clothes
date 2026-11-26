import 'tag.dart';

class Cloth {
  final String id;
  final String orgId;
  final String? storageId;
  final String? storageName;
  final String storageType;
  final String? photoUrl;
  final String? name;
  final String? memo;
  final bool? isPresent;
  final DateTime? createdAt;
  final List<Tag> tags;

  const Cloth({
    required this.id,
    required this.orgId,
    this.storageId,
    this.storageName,
    this.storageType = 'normal',
    this.photoUrl,
    this.name,
    this.memo,
    this.isPresent,
    this.createdAt,
    this.tags = const [],
  });

  factory Cloth.fromMap(Map<String, dynamic> map) => Cloth(
        id: map['id'] as String,
        orgId: map['org_id'] as String,
        storageId: map['storage_id'] as String?,
        storageName:
            (map['storages'] as Map<String, dynamic>?)?['name'] as String?,
        storageType:
            (map['storages'] as Map<String, dynamic>?)?['storage_type']
                    as String? ??
                'normal',
        photoUrl: map['photo_url'] as String?,
        name: map['name'] as String?,
        memo: map['memo'] as String?,
        isPresent: map['is_present'] as bool?,
        createdAt: map['created_at'] != null
            ? DateTime.tryParse(map['created_at'] as String)
            : null,
        tags: (map['clothes_tags'] as List<dynamic>? ?? [])
            .map((t) => Tag.fromJoinMap(t as Map<String, dynamic>))
            .toList(),
      );
}
