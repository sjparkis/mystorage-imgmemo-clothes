import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/storage_location.dart';

class StorageRepository {
  final SupabaseClient _db;

  StorageRepository({SupabaseClient? db})
      : _db = db ?? Supabase.instance.client;

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

  Future<List<StorageLocation>> fetchAll() async {
    final orgId = await getOrCreateOrgId();
    final rows = await _db
        .from('storages')
        .select()
        .eq('org_id', orgId)
        .order('created_at');
    return rows.map((r) => StorageLocation.fromMap(r)).toList();
  }

  Future<StorageLocation> fetchById(String id) async {
    final row = await _db.from('storages').select().eq('id', id).single();
    return StorageLocation.fromMap(row);
  }

  Future<StorageLocation?> fetchByQrCode(String qrCode) async {
    final row = await _db
        .from('storages')
        .select()
        .eq('qr_code', qrCode)
        .maybeSingle();
    if (row == null) return null;
    return StorageLocation.fromMap(row);
  }

  Future<StorageLocation> create({
    required String name,
    String? photoUrl,
    String? description,
  }) async {
    final orgId = await getOrCreateOrgId();
    final row = await _db
        .from('storages')
        .insert({
          'org_id': orgId,
          'name': name,
          'photo_url': photoUrl,
          'description': description,
        })
        .select()
        .single();
    return StorageLocation.fromMap(row);
  }

  Future<void> delete(String id) async {
    await _db.from('storages').delete().eq('id', id);
  }
}
