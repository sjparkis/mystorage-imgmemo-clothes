import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/location.dart';
import 'storage_repository.dart';

class LocationRepository {
  final SupabaseClient _db;

  static const _defaultNames = [
    '드레스룸',
    '방 1',
    '방 2',
    '거실',
    '창고',
    '외부 보관소',
  ];

  LocationRepository({SupabaseClient? db})
      : _db = db ?? Supabase.instance.client;

  Future<String> _getOrgId() => StorageRepository().getOrCreateOrgId();

  Future<List<Location>> fetchAll() async {
    final orgId = await _getOrgId();
    final rows = await _db
        .from('locations')
        .select()
        .eq('org_id', orgId)
        .order('sort_order')
        .order('created_at');

    if (rows.isEmpty) {
      return _seedDefaults(orgId);
    }
    return rows.map((r) => Location.fromMap(r)).toList();
  }

  Future<List<Location>> _seedDefaults(String orgId) async {
    final inserts = _defaultNames
        .asMap()
        .entries
        .map((e) => {'org_id': orgId, 'name': e.value, 'sort_order': e.key})
        .toList();
    final rows = await _db.from('locations').insert(inserts).select();
    return rows.map((r) => Location.fromMap(r)).toList();
  }

  Future<Location> create(String name) async {
    final orgId = await _getOrgId();
    final existing = await _db
        .from('locations')
        .select('sort_order')
        .eq('org_id', orgId)
        .order('sort_order', ascending: false)
        .limit(1);
    final nextOrder =
        existing.isEmpty ? 0 : (existing.first['sort_order'] as int) + 1;
    final row = await _db
        .from('locations')
        .insert({'org_id': orgId, 'name': name, 'sort_order': nextOrder})
        .select()
        .single();
    return Location.fromMap(row);
  }

  Future<void> update(String id, String name) async {
    final rows = await _db
        .from('locations')
        .update({'name': name})
        .eq('id', id)
        .select();
    if (rows.isEmpty) throw Exception('위치를 찾을 수 없습니다.');
  }

  Future<void> delete(String id) async {
    await _db.from('locations').delete().eq('id', id);
  }
}
