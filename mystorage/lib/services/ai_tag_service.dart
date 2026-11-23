import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/tag.dart';

class AiTagService {
  Future<List<Tag>> analyze(String imageUrl) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'analyze-clothing',
        body: {'imageUrl': imageUrl},
      );
      final tags = (response.data['tags'] as List<dynamic>).map((t) {
        final map = t as Map<String, dynamic>;
        return Tag(
          id: '',
          name: map['name'] as String,
          category: map['category'] as String,
          aiGenerated: true,
        );
      }).toList();
      return tags;
    } catch (_) {
      return [];
    }
  }
}
