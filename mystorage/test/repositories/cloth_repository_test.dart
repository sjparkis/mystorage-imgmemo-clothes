import 'package:flutter_test/flutter_test.dart';
import 'package:mystorage/data/models/cloth.dart';
import 'package:mystorage/data/models/tag.dart';
import 'package:mystorage/data/repositories/cloth_repository.dart';

void main() {
  test('ClothRepository is importable', () {
    expect(ClothRepository.new, isNotNull);
  });

  test('Cloth.fromMap parses correctly with tags', () {
    final map = {
      'id': 'cloth-1',
      'org_id': 'org-1',
      'storage_id': 'storage-1',
      'photo_url': 'https://example.com/photo.jpg',
      'name': '겨울 코트',
      'clothes_tags': [
        {
          'ai_generated': true,
          'tags': {'id': 'tag-1', 'name': '코트', 'category': 'type'},
        },
      ],
    };
    final cloth = Cloth.fromMap(map);
    expect(cloth.id, 'cloth-1');
    expect(cloth.name, '겨울 코트');
    expect(cloth.tags.length, 1);
    expect(cloth.tags.first.name, '코트');
    expect(cloth.tags.first.aiGenerated, true);
  });

  test('Cloth.fromMap handles empty tags', () {
    final map = {
      'id': 'cloth-2',
      'org_id': 'org-1',
      'storage_id': null,
      'photo_url': null,
      'name': null,
      'clothes_tags': [],
    };
    final cloth = Cloth.fromMap(map);
    expect(cloth.tags, isEmpty);
    expect(cloth.name, isNull);
    expect(cloth.photoUrl, isNull);
  });
}
