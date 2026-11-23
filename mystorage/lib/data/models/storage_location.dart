class StorageLocation {
  final String id;
  final String orgId;
  final String name;
  final String? photoUrl;
  final String qrCode;
  final String? description;

  const StorageLocation({
    required this.id,
    required this.orgId,
    required this.name,
    this.photoUrl,
    required this.qrCode,
    this.description,
  });

  factory StorageLocation.fromMap(Map<String, dynamic> map) => StorageLocation(
        id: map['id'] as String,
        orgId: map['org_id'] as String,
        name: map['name'] as String,
        photoUrl: map['photo_url'] as String?,
        qrCode: map['qr_code'] as String,
        description: map['description'] as String?,
      );
}
