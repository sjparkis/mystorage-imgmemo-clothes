import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/models/storage_location.dart';
import 'storage_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = StorageRepository();
  late Future<List<StorageLocation>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchAll();
  }

  void _reload() => setState(() {
        _future = _repo.fetchAll();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 보관함',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => context.push('/qr-scan'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: FutureBuilder<List<StorageLocation>>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('오류: ${snap.error}'));
          }
          final storages = snap.data ?? [];
          if (storages.isEmpty) {
            return const Center(child: Text('보관함을 추가해 주세요'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: storages.length,
            itemBuilder: (_, i) => StorageCard(
              storage: storages[i],
              onTap: () => context.push('/storage/${storages[i].id}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/storage/add');
          _reload();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '검색',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '나의',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (i) {
          switch (i) {
            case 1:
              context.push('/search');
            case 2:
              context.push('/qr-scan');
          }
        },
      ),
    );
  }
}
