import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<Map<String, dynamic>> _stats;

  @override
  void initState() {
    super.initState();
    _stats = Supabase.instance.client.from('admin_stats').select().single();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _stats,
        builder: (_, snap) {
          if (snap.hasError) {
            return Center(child: Text('오류: ${snap.error}'));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final s = snap.data!;
          String v(String key) => (s[key] ?? 0).toString();
          return GridView.count(
            crossAxisCount: 2, padding: const EdgeInsets.all(16), mainAxisSpacing: 12, crossAxisSpacing: 12,
            children: [
              _StatCard(label: '전체 사용자', value: v('total_users'), icon: Icons.people),
              _StatCard(label: '전체 조직', value: v('total_orgs'), icon: Icons.business),
              _StatCard(label: '전체 보관함', value: v('total_storages'), icon: Icons.inventory_2),
              _StatCard(label: '전체 옷', value: v('total_clothes'), icon: Icons.checkroom),
              _StatCard(label: '광고제거 구독', value: v('ad_free_count'), icon: Icons.block),
              _StatCard(label: '기본 구독', value: v('basic_count'), icon: Icons.star),
              _StatCard(label: 'AI 음성 구독', value: v('ai_voice_count'), icon: Icons.mic),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
