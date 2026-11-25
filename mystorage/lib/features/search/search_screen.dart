import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../data/models/cloth.dart';
import 'voice_search_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repo = ClothRepository();
  final _queryCtrl = TextEditingController();
  List<Cloth> _results = [];
  bool _loading = false;
  bool _searched = false;

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() { _loading = true; _searched = true; });
    try {
      final results = await _repo.search(_queryCtrl.text);
      if (mounted) setState(() => _results = results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('검색 오류: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        surfaceTintColor: Colors.transparent,
        title: Text('SEARCH', style: GoogleFonts.cormorant(
          fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 3,
          color: const Color(0xFF2C2416),
        ).copyWith(fontFamilyFallback: const ['ChosunSm'])),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E0D5)),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFFFBF7),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryCtrl,
                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    decoration: InputDecoration(
                      hintText: '옷 이름, 태그, 메모로 검색',
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9B8E7E)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                      prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF9B8E7E)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _search,
                  child: Container(
                    width: 44,
                    height: 44,
                    color: const Color(0xFF8B7355),
                    child: const Icon(Icons.search, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                VoiceSearchButton(
                  onResult: (text, filters) {
                    _queryCtrl.text = text;
                    _search();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8E0D5)),
          if (_loading) const LinearProgressIndicator(
            color: Color(0xFF8B7355),
            backgroundColor: Color(0xFFE8E0D5),
          ),
          Expanded(
            child: !_searched
                ? Center(
                    child: Text(
                      '이름 또는 태그로 검색해 보세요',
                      style: GoogleFonts.inter(
                        fontSize: 13, color: const Color(0xFF9B8E7E)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                  )
                : _results.isEmpty
                    ? Center(
                        child: Text(
                          '검색 결과가 없습니다',
                          style: GoogleFonts.inter(
                            fontSize: 13, color: const Color(0xFF9B8E7E)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _results.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Color(0xFFE8E0D5)),
                        itemBuilder: (_, i) {
                          final cloth = _results[i];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            leading: cloth.photoUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.zero,
                                    child: Image.network(
                                      cloth.photoUrl!,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: 56,
                                    height: 56,
                                    color: const Color(0xFFEDE7DD),
                                    child: const Icon(Icons.checkroom,
                                        size: 24, color: Color(0xFFBBAA95)),
                                  ),
                            title: Text(
                              cloth.name ?? '이름 없음',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2C2416),
                              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (cloth.storageName != null) ...[
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(Icons.inventory_2_outlined,
                                          size: 11, color: Color(0xFF8B7355)),
                                      const SizedBox(width: 4),
                                      Text(
                                        cloth.storageName!,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF8B7355),
                                          fontWeight: FontWeight.w500,
                                        ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                                      ),
                                    ],
                                  ),
                                ],
                                if (cloth.tags.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    cloth.tags.map((t) => t.name).join('  ·  '),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: const Color(0xFF9B8E7E),
                                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (cloth.memo != null && cloth.memo!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    cloth.memo!,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: const Color(0xFF7A6E63),
                                      fontStyle: FontStyle.italic,
                                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (cloth.createdAt != null) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    _formatDate(cloth.createdAt!),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: const Color(0xFFBBAA95),
                                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                                  ),
                                ],
                              ],
                            ),
                            onTap: () => context.push('/cloth/${cloth.id}'),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
}
