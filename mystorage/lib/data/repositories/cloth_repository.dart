import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cloth.dart';
import '../models/tag.dart';
import 'storage_repository.dart';

class ClothRepository {
  final SupabaseClient _db;

  ClothRepository({SupabaseClient? db})
      : _db = db ?? Supabase.instance.client;

  Future<List<Cloth>> fetchByStorage(String storageId) async {
    final rows = await _db
        .from('clothes')
        .select('*, storages(name), clothes_tags(ai_generated, tags(id, name, category))')
        .eq('storage_id', storageId)
        .order('created_at');
    return rows.map((r) => Cloth.fromMap(r)).toList();
  }

  Future<String> getOrCreateOrgId() => StorageRepository().getOrCreateOrgId();

  Future<Map<String, int>> fetchCountsByOrg() async {
    final orgId = await getOrCreateOrgId();
    final rows = await _db
        .from('clothes')
        .select('storage_id')
        .eq('org_id', orgId);
    final counts = <String, int>{};
    for (final row in rows) {
      final id = row['storage_id'] as String?;
      if (id == null) continue;
      counts[id] = (counts[id] ?? 0) + 1;
    }
    return counts;
  }

  Future<List<Cloth>> search(String query) async {
    final orgId = await getOrCreateOrgId();
    final rows = await _db
        .from('clothes')
        .select('*, storages(name), clothes_tags(ai_generated, tags(id, name, category))')
        .eq('org_id', orgId)
        .order('created_at');
    final all = rows.map((r) => Cloth.fromMap(r)).toList();
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((c) {
      final nameMatch = c.name?.toLowerCase().contains(q) ?? false;
      final tagMatch = c.tags.any((t) => t.name.toLowerCase().contains(q));
      final memoMatch = c.memo?.toLowerCase().contains(q) ?? false;
      return nameMatch || tagMatch || memoMatch;
    }).toList();
  }

  Future<Cloth> create({
    required String storageId,
    required String orgId,
    String? photoUrl,
    String? name,
    String? memo,
    List<Tag> tags = const [],
  }) async {
    final cloth = await _db
        .from('clothes')
        .insert({
          'storage_id': storageId,
          'org_id': orgId,
          'photo_url': photoUrl,
          'name': name,
          'memo': memo,
          'created_by': _db.auth.currentUser!.id,
        })
        .select()
        .single();

    for (final tag in tags) {
      final tagRow = await _db
          .from('tags')
          .upsert(
            {'name': tag.name, 'category': tag.category},
            onConflict: 'name',
          )
          .select()
          .single();
      await _db.from('clothes_tags').insert({
        'cloth_id': cloth['id'],
        'tag_id': tagRow['id'],
        'ai_generated': tag.aiGenerated,
      });
    }

    final result = await _db
        .from('clothes')
        .select('*, storages(name), clothes_tags(ai_generated, tags(id, name, category))')
        .eq('id', cloth['id'] as String)
        .single();
    return Cloth.fromMap(result);
  }

  Future<void> updateTags(String clothId, List<Tag> tags) async {
    await _db.from('clothes_tags').delete().eq('cloth_id', clothId);
    for (final tag in tags) {
      final tagRow = await _db
          .from('tags')
          .upsert({'name': tag.name, 'category': tag.category}, onConflict: 'name')
          .select()
          .single();
      await _db.from('clothes_tags').insert({
        'cloth_id': clothId,
        'tag_id': tagRow['id'],
        'ai_generated': tag.aiGenerated,
      });
    }
  }

  Future<void> updateNameAndTags(String clothId, {String? name, List<Tag>? tags}) async {
    if (name != null) {
      await _db.from('clothes').update({'name': name}).eq('id', clothId);
    }
    if (tags != null) await updateTags(clothId, tags);
  }

  Future<void> updateStorage(String clothId, String storageId) async {
    await _db
        .from('clothes')
        .update({'storage_id': storageId})
        .eq('id', clothId);
  }

  Future<void> updatePresence(String clothId, bool? isPresent) async {
    await _db
        .from('clothes')
        .update({'is_present': isPresent})
        .eq('id', clothId);
  }

  Future<void> delete(String id) async {
    await _db.from('clothes').delete().eq('id', id);
  }
}
