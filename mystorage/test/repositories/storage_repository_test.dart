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

  test('StorageLocation defaults storageType to normal', () {
    final map = {
      'id': 'id1',
      'org_id': 'org1',
      'name': '겨울 옷장',
      'qr_code': 'qr1',
    };
    final loc = StorageLocation.fromMap(map);
    expect(loc.storageType, 'normal');
    expect(loc.isSystem, false);
    expect(loc.isTrash, false);
    expect(loc.isForSale, false);
  });

  test('StorageLocation trash type sets isSystem and isTrash', () {
    final map = {
      'id': 'id2',
      'org_id': 'org1',
      'name': '휴지통',
      'qr_code': 'qr2',
      'storage_type': 'trash',
    };
    final loc = StorageLocation.fromMap(map);
    expect(loc.storageType, 'trash');
    expect(loc.isSystem, true);
    expect(loc.isTrash, true);
    expect(loc.isForSale, false);
  });

  test('StorageLocation for_sale type sets isSystem and isForSale', () {
    final map = {
      'id': 'id3',
      'org_id': 'org1',
      'name': '판매 보관함',
      'qr_code': 'qr3',
      'storage_type': 'for_sale',
    };
    final loc = StorageLocation.fromMap(map);
    expect(loc.storageType, 'for_sale');
    expect(loc.isSystem, true);
    expect(loc.isTrash, false);
    expect(loc.isForSale, true);
  });
}
