import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/cloth.dart';

class OrganizeGroup {
  final String name;
  final List<String> clothIds;
  final String reason;

  const OrganizeGroup({
    required this.name,
    required this.clothIds,
    required this.reason,
  });

  factory OrganizeGroup.fromMap(Map<String, dynamic> m) => OrganizeGroup(
        name: m['name'] as String,
        clothIds: List<String>.from(m['clothIds'] as List),
        reason: m['reason'] as String? ?? '',
      );
}

class OrganizeService {
  Future<List<OrganizeGroup>> analyze({
    required List<Cloth> clothes,
    required List<String> criteria,
    required int maxPerBox,
  }) async {
    final payload = clothes
        .map((c) => {
              'id': c.id,
              'name': c.name,
              'tags': c.tags
                  .map((t) => {'name': t.name, 'category': t.category})
                  .toList(),
            })
        .toList();

    final res = await Supabase.instance.client.functions.invoke(
      'organize-clothes',
      body: {
        'clothes': payload,
        'criteria': criteria,
        'maxPerBox': maxPerBox,
      },
    );

    if (res.data == null) throw Exception('AI 분석 응답 없음');
    final groups = res.data['groups'] as List?;
    if (groups == null) throw Exception('분석 결과를 파싱할 수 없습니다');
    return groups.map((g) => OrganizeGroup.fromMap(g as Map<String, dynamic>)).toList();
  }
}
