import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<StorageLocation> _storages = [];
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
      final storages = await _repo.fetchAll();
      if (mounted) setState(() { _storages = storages; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
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
          ),
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
                              fontSize: 13, color: const Color(0xFF9B8E7E))),
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
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '+ 버튼으로 보관함을 추가해 보세요',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF9B8E7E),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 28,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _storages.length,
                      itemBuilder: (_, i) => StorageCard(
                        storage: _storages[i],
                        onTap: () async {
                          await context.push('/storage/${_storages[i].id}');
                          _load();
                        },
                      ),
                    ),
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
      ),
    );
  }
}
