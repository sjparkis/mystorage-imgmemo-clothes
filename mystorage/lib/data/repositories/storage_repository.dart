import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/storage_location.dart';

class StorageRepository {
  final SupabaseClient _db;
  static String? _cachedOrgId;

  StorageRepository({SupabaseClient? db})
      : _db = db ?? Supabase.instance.client;

  static void clearCache() => _cachedOrgId = null;

  Future<String> getOrCreateOrgId() async {
    if (_cachedOrgId != null) return _cachedOrgId!;

    final userId = _db.auth.currentUser!.id;
    final existing = await _db
        .from('organization_members')
        .select('org_id')
        .eq('user_id', userId)
        .maybeSingle();
    if (existing != null) {
      _cachedOrgId = existing['org_id'] as String;
      return _cachedOrgId!;
    }

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
    _cachedOrgId = org['id'] as String;
    return _cachedOrgId!;
  }

  Future<List<StorageLocation>> fetchAll() async {
    final orgId = await getOrCreateOrgId();
    final rows = await _db
        .from('storages')
        .select('*, locations(id, name)')
        .eq('org_id', orgId)
        .order('created_at');
    return rows.map((r) => StorageLocation.fromMap(r)).toList();
  }

  Future<StorageLocation> fetchById(String id) async {
    final orgId = await getOrCreateOrgId();
    final row = await _db
        .from('storages')
        .select('*, locations(id, name)')
        .eq('id', id)
        .eq('org_id', orgId)
        .single();
    return StorageLocation.fromMap(row);
  }

  Future<StorageLocation?> fetchByQrCode(String qrCode) async {
    final row = await _db
        .from('storages')
        .select('*, locations(id, name)')
        .eq('qr_code', qrCode)
        .maybeSingle();
    if (row == null) return null;
    return StorageLocation.fromMap(row);
  }

  Future<StorageLocation> create({
    required String name,
    String? photoUrl,
    String? description,
    String? locationId,
  }) async {
    final orgId = await getOrCreateOrgId();
    final row = await _db
        .from('storages')
        .insert({
          'org_id': orgId,
          'name': name,
          'photo_url': photoUrl,
          'description': description,
          'location_id': locationId,
        })
        .select('*, locations(id, name)')
        .single();
    return StorageLocation.fromMap(row);
  }

  Future<StorageLocation> update({
    required String id,
    required String name,
    String? photoUrl,
    Object? locationId = _keep,
  }) async {
    final data = <String, dynamic>{'name': name, 'photo_url': photoUrl};
    if (locationId != _keep) data['location_id'] = locationId;
    final row = await _db
        .from('storages')
        .update(data)
        .eq('id', id)
        .select('*, locations(id, name)')
        .single();
    return StorageLocation.fromMap(row);
  }

  static const _keep = Object();

  Future<void> delete(String id) async {
    await _db.from('storages').delete().eq('id', id);
  }

  Future<void> ensureSystemStorages(String orgId) async {
    for (final type in ['trash', 'for_sale']) {
      final name = type == 'trash' ? '휴지통' : '판매 보관함';
      final existing = await _db
          .from('storages')
          .select('id')
          .eq('org_id', orgId)
          .eq('storage_type', type)
          .maybeSingle();
      if (existing == null) {
        await _db.from('storages').insert({
          'org_id': orgId,
          'name': name,
          'storage_type': type,
        });
      }
    }
  }

  Future<StorageLocation?> fetchSystemStorage(String type) async {
    final orgId = await getOrCreateOrgId();
    final row = await _db
        .from('storages')
        .select('*, locations(id, name)')
        .eq('org_id', orgId)
        .eq('storage_type', type)
        .maybeSingle();
    return row == null ? null : StorageLocation.fromMap(row);
  }
}
