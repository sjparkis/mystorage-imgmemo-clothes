import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'storage_repository.dart';

class OrgMember {
  final String userId;
  final String email;
  final String role;
  final DateTime joinedAt;

  const OrgMember({
    required this.userId,
    required this.email,
    required this.role,
    required this.joinedAt,
  });

  bool get isOwner => role == 'owner';
}

class FamilyRepository {
  final SupabaseClient _db;

  FamilyRepository({SupabaseClient? db})
      : _db = db ?? Supabase.instance.client;

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random.secure();
    final raw = List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
    return '${raw.substring(0, 3)}-${raw.substring(3)}';
  }

  Future<List<OrgMember>> fetchMembers() async {
    final rows = await _db.rpc('get_org_members') as List;
    return rows.map((r) => OrgMember(
      userId: r['user_id'] as String,
      email: r['email'] as String,
      role: r['role'] as String,
      joinedAt: DateTime.parse(r['joined_at'] as String),
    )).toList();
  }

  Future<String> createInviteCode() async {
    final orgId = await StorageRepository().getOrCreateOrgId();
    final code = _generateCode();
    await _db.from('org_invites').insert({
      'org_id': orgId,
      'code': code,
      'created_by': _db.auth.currentUser!.id,
    });
    return code;
  }

  Future<String?> getActiveInviteCode() async {
    final orgId = await StorageRepository().getOrCreateOrgId();
    final row = await _db
        .from('org_invites')
        .select('code, expires_at')
        .eq('org_id', orgId)
        .isFilter('used_at', null)
        .gt('expires_at', DateTime.now().toIso8601String())
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return row?['code'] as String?;
  }

  Future<void> joinWithCode(String code) async {
    final cleaned = code.replaceAll('-', '').toUpperCase();
    final formatted = '${cleaned.substring(0, 3)}-${cleaned.substring(3)}';
    final result = await _db.rpc('join_org_with_code', params: {'invite_code': formatted});
    StorageRepository.clearCache();
    if (result is Map && result['success'] != true) {
      throw Exception('참여 실패');
    }
  }

  Future<void> removeMember(String userId) async {
    await _db.rpc('remove_org_member', params: {'target_user_id': userId});
  }
}
