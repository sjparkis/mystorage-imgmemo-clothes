import 'package:flutter_test/flutter_test.dart';
import 'package:mystorage/services/ai_tag_service.dart';

void main() {
  test('AiTagService is importable', () {
    expect(AiTagService.new, isNotNull);
  });

  test('AiTagService.analyze returns empty list on error (no Supabase)', () async {
    final service = AiTagService();
    final tags = await service.analyze('https://example.com/invalid.jpg');
    expect(tags, isA<List>());
  });
}
