import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _users = [];
  bool _loadingStats = true;
  bool _loadingUsers = true;
  String? _statsError;
  String? _usersError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStats();
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    setState(() { _loadingStats = true; _statsError = null; });
    try {
      final row = await Supabase.instance.client.from('admin_stats').select().single();
      if (mounted) setState(() { _stats = row; _loadingStats = false; });
    } catch (e) {
      if (mounted) setState(() { _statsError = e.toString(); _loadingStats = false; });
    }
  }

  Future<void> _loadUsers() async {
    setState(() { _loadingUsers = true; _usersError = null; });
    try {
      final rows = await Supabase.instance.client.rpc('get_all_users_admin');
      if (mounted) {
        setState(() {
          _users = List<Map<String, dynamic>>.from(rows as List);
          _loadingUsers = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _usersError = e.toString(); _loadingUsers = false; });
    }
  }

  Future<void> _changeRole(String userId, String currentRole) async {
    final roles = ['user', 'manager', 'admin'];
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: const Color(0xFFFFFBF7),
        title: Text(
          'ROLE 변경',
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF2C2416))
              .copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        children: roles.map((r) => SimpleDialogOption(
          onPressed: () => Navigator.pop(ctx, r),
          child: Row(
            children: [
              Icon(
                r == currentRole ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                size: 16,
                color: r == currentRole ? const Color(0xFF8B7355) : const Color(0xFFBBAA95),
              ),
              const SizedBox(width: 10),
              Text(
                r.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: r == currentRole ? FontWeight.w700 : FontWeight.w400,
                  color: const Color(0xFF2C2416),
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ],
          ),
        )).toList(),
      ),
    );
    if (selected == null || selected == currentRole) return;
    try {
      await Supabase.instance.client.rpc('admin_set_user_role', params: {
        'target_user_id': userId,
        'new_role': selected,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$selected 로 변경됐습니다')),
        );
        _loadUsers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('변경 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1510),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'ADMIN',
          style: GoogleFonts.cormorant(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: const Color(0xFF8B7355),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B7355),
          labelColor: const Color(0xFF8B7355),
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
          tabs: const [
            Tab(text: 'STATS'),
            Tab(text: 'USERS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatsTab(),
          _buildUsersTab(),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    if (_loadingStats) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF8B7355)));
    }
    if (_statsError != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(AppLocalizations.of(context).loadError(_statsError!), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(onPressed: _loadStats, child: Text(AppLocalizations.of(context).retry)),
        ]),
      );
    }
    if (_stats == null) {
      return Center(child: Text(AppLocalizations.of(context).adminNoData));
    }
    final s = _stats!;
    String v(String key) => (s[key] ?? 0).toString();
    final items = [
      (AppLocalizations.of(context).adminTotalUsers, v('total_users'), Icons.people_outline),
      (AppLocalizations.of(context).adminTotalOrgs, v('total_orgs'), Icons.business_outlined),
      (AppLocalizations.of(context).adminTotalStorages, v('total_storages'), Icons.inventory_2_outlined),
      (AppLocalizations.of(context).adminTotalClothes, v('total_clothes'), Icons.checkroom_outlined),
      ('광고제거 구독', v('ad_free_count'), Icons.block_outlined),
      ('기본 구독', v('basic_count'), Icons.star_outline),
      ('AI 음성 구독', v('ai_voice_count'), Icons.mic_outlined),
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final (label, value, icon) = items[i];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF7),
            border: Border.all(color: const Color(0xFFE8E0D5)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 28, color: const Color(0xFF8B7355)),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C2416),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF9B8E7E), letterSpacing: 0.5)
                  .copyWith(fontFamilyFallback: const ['ChosunSm']),
              textAlign: TextAlign.center,
            ),
          ]),
        );
      },
    );
  }

  Widget _buildUsersTab() {
    if (_loadingUsers) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF8B7355)));
    }
    if (_usersError != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(AppLocalizations.of(context).loadError(_usersError!), textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13).copyWith(fontFamilyFallback: const ['ChosunSm'])),
          const SizedBox(height: 12),
          TextButton(onPressed: _loadUsers, child: Text(AppLocalizations.of(context).retry)),
        ]),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _users.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
      itemBuilder: (_, i) {
        final u = _users[i];
        final role = u['role'] as String? ?? 'user';
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEDE7DD),
            ),
            child: const Icon(Icons.person_outline, size: 20, color: Color(0xFF8B7355)),
          ),
          title: Text(
            u['email'] as String? ?? '',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF2C2416))
                .copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          subtitle: Text(
            role.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              color: role == 'admin'
                  ? const Color(0xFF8B7355)
                  : role == 'manager'
                      ? const Color(0xFF5B8C5A)
                      : const Color(0xFFBBAA95),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF8B7355)),
            onPressed: () => _changeRole(u['user_id'] as String, role),
          ),
        );
      },
    );
  }
}
