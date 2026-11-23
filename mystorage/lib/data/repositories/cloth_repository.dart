import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cloth.dart';
import '../models/tag.dart';

class ClothRepository {
  final SupabaseClient _db;

  ClothRepository({SupabaseClient? db})
      : _db = db ?? Supabase.instance.client;

  Future<List<Cloth>> fetchByStorage(String storageId) async {
    final rows = await _db
        .from('clothes')
        .select('*, clothes_tags(ai_generated, tags(id, name, category))')
        .eq('storage_id', storageId)
        .order('created_at');
    return rows.map((r) => Cloth.fromMap(r)).toList();
  }

  Future<String> getOrCreateOrgId() async {
    final userId = _db.auth.currentUser!.id;
    final existing = await _db
        .from('organization_members')
        .select('org_id')
        .eq('user_id', userId)
        .maybeSingle();
    if (existing != null) return existing['org_id'] as String;

    final org = await _db
        .from('organizations')
        .insert({'name': '내 보관함', 'owner_id': userId})
        .select()
        .single();

    await _db.from('organization_members').insert({
      'org_id': org['id'],
      'user_id': userId,
      'role': 'owner',
    });
    return org['id'] as String;
  }

  Future<List<Cloth>> search(String query) async {
    final orgId = await getOrCreateOrgId();
    var q = _db
        .from('clothes')
        .select('*, clothes_tags(ai_generated, tags(id, name, category))')
        .eq('org_id', orgId);
    if (query.isNotEmpty) {
      q = q.ilike('name', '%$query%');
    }
    final rows = await q.order('created_at');
    return rows.map((r) => Cloth.fromMap(r)).toList();
  }

  Future<Cloth> create({
    required String storageId,
    required String orgId,
    String? photoUrl,
    String? name,
    List<Tag> tags = const [],
  }) async {
    final cloth = await _db
        .from('clothes')
        .insert({
          'storage_id': storageId,
          'org_id': orgId,
          'photo_url': photoUrl,
          'name': name,
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
        .select('*, clothes_tags(ai_generated, tags(id, name, category))')
        .eq('id', cloth['id'] as String)
        .single();
    return Cloth.fromMap(result);
  }

  Future<void> delete(String id) async {
    await _db.from('clothes').delete().eq('id', id);
  }
}
