import 'package:supabase_flutter/supabase_flutter.dart';

class UserSettingsRepository {
  final SupabaseClient _db;

  UserSettingsRepository({SupabaseClient? db})
      : _db = db ?? Supabase.instance.client;

  static Map<String, bool> get defaultSettings => {
        'show_trash': true,
        'show_sale': true,
      };

  Future<void> ensureUserSettings() async {
    final userId = _db.auth.currentUser!.id;
    await _db.from('user_settings').upsert(
      {'user_id': userId},
      onConflict: 'user_id',
      ignoreDuplicates: true,
    );
  }

  Future<Map<String, dynamic>> fetchSettings() async {
    final userId = _db.auth.currentUser!.id;
    final row = await _db
        .from('user_settings')
        .select('show_trash, show_sale, role')
        .eq('user_id', userId)
        .maybeSingle();
    return {
      'show_trash': row?['show_trash'] as bool? ?? true,
      'show_sale': row?['show_sale'] as bool? ?? true,
      'role': row?['role'] as String? ?? 'user',
    };
  }

  Future<String> fetchRole() async {
    final userId = _db.auth.currentUser!.id;
    final row = await _db
        .from('user_settings')
        .select('role')
        .eq('user_id', userId)
        .maybeSingle();
    return row?['role'] as String? ?? 'user';
  }

  Future<void> updateShowTrash(bool value) async {
    final userId = _db.auth.currentUser!.id;
    await _db.from('user_settings').upsert(
      {
        'user_id': userId,
        'show_trash': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'user_id',
    );
  }

  Future<void> updateShowSale(bool value) async {
    final userId = _db.auth.currentUser!.id;
    await _db.from('user_settings').upsert(
      {
        'user_id': userId,
        'show_sale': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'user_id',
    );
  }
}
