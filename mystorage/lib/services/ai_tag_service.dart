import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/tag.dart';

class AiTagService {
  Future<({List<Tag> tags, String? name})> analyze(
    Uint8List bytes, {
    String contentType = 'image/jpeg',
  }) async {
    return _invoke({'base64Image': base64Encode(bytes), 'contentType': contentType});
  }

  Future<({List<Tag> tags, String? name})> analyzeUrl(String imageUrl) async {
    return _invoke({'imageUrl': imageUrl});
  }

  Future<({List<Tag> tags, String? name})> _invoke(Map<String, dynamic> body) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'analyze-clothing',
        body: body,
      );
      final data = response.data as Map<String, dynamic>;
      final tags = (data['tags'] as List<dynamic>? ?? []).map((t) {
        final map = t as Map<String, dynamic>;
        return Tag(
          id: '',
          name: map['name'] as String,
          category: map['category'] as String,
          aiGenerated: true,
        );
      }).toList();
      return (tags: tags, name: data['name'] as String?);
    } catch (_) {
      return (tags: <Tag>[], name: null);
    }
  }
}
