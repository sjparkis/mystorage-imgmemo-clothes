import 'package:flutter_test/flutter_test.dart';
import 'package:mystorage/data/models/storage_location.dart';
import 'package:mystorage/data/repositories/storage_repository.dart';

void main() {
  test('StorageRepository is importable', () {
    expect(StorageRepository.new, isNotNull);
  });

  test('StorageLocation.fromMap parses correctly', () {
    final map = {
      'id': 'test-id',
      'org_id': 'org-id',
      'name': '겨울 옷장',
      'photo_url': null,
      'qr_code': 'qr-uuid',
      'description': '베란다 옷장',
    };
    final location = StorageLocation.fromMap(map);
    expect(location.id, 'test-id');
    expect(location.orgId, 'org-id');
    expect(location.name, '겨울 옷장');
    expect(location.qrCode, 'qr-uuid');
    expect(location.photoUrl, isNull);
    expect(location.description, '베란다 옷장');
  });
}
