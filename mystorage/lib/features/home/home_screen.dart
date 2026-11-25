import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../data/models/storage_location.dart';
import 'storage_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = StorageRepository();
  final _clothRepo = ClothRepository();
  List<StorageLocation> _storages = [];
  Map<String, int> _clothCounts = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        _repo.fetchAll(),
        _clothRepo.fetchCountsByOrg(),
      ]);
      if (mounted) {
        setState(() {
          _storages = results[0] as List<StorageLocation>;
          _clothCounts = results[1] as Map<String, int>;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Widget _buildGroupedGrid() {
    // 위치별 그룹: 위치 없음은 맨 뒤
    final grouped = <String?, List<StorageLocation>>{};
    for (final s in _storages) {
      grouped.putIfAbsent(s.locationName, () => []).add(s);
    }
    final keys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      });

    return CustomScrollView(
      slivers: [
        for (final key in keys) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, key == keys.first ? 24 : 32, 20, 10),
              child: Row(
                children: [
                  const Icon(Icons.place_outlined, size: 13, color: Color(0xFF8B7355)),
                  const SizedBox(width: 6),
                  Text(
                    key ?? '위치 미설정',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: key != null
                          ? const Color(0xFF8B7355)
                          : const Color(0xFFBBAA95),
                      letterSpacing: 1.2,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final s = grouped[key]![i];
                  return StorageCard(
                    storage: s,
                    clothCount: _clothCounts[s.id] ?? 0,
                    onTap: () async {
                      await context.push('/storage/${s.id}');
                      _load();
                    },
                  );
                },
                childCount: grouped[key]!.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 28,
                childAspectRatio: 0.75,
              ),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'MYSTORAGE',
          style: GoogleFonts.cormorant(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
            color: const Color(0xFF2C2416),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 20, color: Color(0xFF2C2416)),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, size: 20, color: Color(0xFF2C2416)),
            onPressed: () => context.push('/qr-scan'),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E0D5)),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Color(0xFF8B7355),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('불러오기 실패',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: const Color(0xFF9B8E7E)).copyWith(fontFamilyFallback: const ['ChosunSm'])),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _error!,
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFCC5C5C)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(onPressed: _load, child: const Text('다시 시도')),
                    ],
                  ),
                )
              : _storages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.inventory_2_outlined,
                              size: 44, color: Color(0xFFD5C9BB)),
                          const SizedBox(height: 20),
                          Text(
                            'YOUR COLLECTION',
                            style: GoogleFonts.cormorant(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C2416),
                              letterSpacing: 3,
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '+ 버튼으로 보관함을 추가해 보세요',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF9B8E7E),
                              letterSpacing: 0.5,
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                        ],
                      ),
                    )
                  : _buildGroupedGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/storage/add');
          _load();
        },
        backgroundColor: const Color(0xFF8B7355),
        foregroundColor: Colors.white,
        elevation: 0,
        child: const Icon(Icons.add, size: 20),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBF7),
          border: Border(top: BorderSide(color: Color(0xFFE8E0D5))),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          height: 60,
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
              icon: Icon(Icons.qr_code_scanner_outlined),
              selectedIcon: Icon(Icons.qr_code_scanner),
              label: 'QR',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_fix_high_outlined),
              selectedIcon: Icon(Icons.auto_fix_high),
              label: 'AI 정리',
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
              case 3:
                context.push('/organize');
              case 4:
                context.push('/profile');
            }
          },
        ),
      ),
    );
  }
}
