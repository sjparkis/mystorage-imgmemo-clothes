import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/models/cloth.dart';
import '../../services/organize_service.dart';

enum _Phase { settings, loading, results }

class OrganizeScreen extends StatefulWidget {
  const OrganizeScreen({super.key});
  @override
  State<OrganizeScreen> createState() => _OrganizeScreenState();
}

class _OrganizeScreenState extends State<OrganizeScreen> {
  final _clothRepo = ClothRepository();
  final _storageRepo = StorageRepository();
  final _service = OrganizeService();

  final _criteria = <String>{'계절별'};
  int _maxPerBox = 10;
  _Phase _phase = _Phase.settings;
  List<OrganizeGroup> _groups = [];
  List<Cloth> _allClothes = [];
  bool _applying = false;
  String? _error;

  static const _criteriaOptions = ['계절별', '소재별', '색상별'];

  Future<void> _analyze() async {
    setState(() { _phase = _Phase.loading; _error = null; });
    try {
      final storages = await _storageRepo.fetchAll();
      final all = <Cloth>[];
      for (final s in storages) {
        all.addAll(await _clothRepo.fetchByStorage(s.id));
      }
      if (all.isEmpty) {
        setState(() { _phase = _Phase.settings; _error = '등록된 의류가 없습니다.'; });
        return;
      }
      _allClothes = all;
      final groups = await _service.analyze(
        clothes: all,
        criteria: _criteria.toList(),
        maxPerBox: _maxPerBox,
      );
      if (mounted) setState(() { _groups = groups; _phase = _Phase.results; });
    } catch (e) {
      if (mounted) setState(() { _phase = _Phase.settings; _error = 'AI 분석 실패: $e'; });
    }
  }

  Future<void> _apply() async {
    setState(() => _applying = true);
    try {
      for (final group in _groups) {
        final storage = await _storageRepo.create(name: group.name);
        for (final clothId in group.clothIds) {
          await _clothRepo.updateStorage(clothId, storage.id);
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('새 보관함에 적용됐습니다.')),
        );
        setState(() { _phase = _Phase.settings; _groups = []; });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('적용 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _applying = false);
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
          'AI ORGANIZER',
          style: GoogleFonts.cormorant(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: const Color(0xFF2C2416),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E0D5)),
        ),
      ),
      body: switch (_phase) {
        _Phase.settings => _buildSettings(),
        _Phase.loading => _buildLoading(),
        _Phase.results => _buildResults(),
      },
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('분류 기준'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _criteriaOptions.map((opt) {
              final selected = _criteria.contains(opt);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected && _criteria.length > 1) {
                    _criteria.remove(opt);
                  } else {
                    _criteria.add(opt);
                  }
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF8B7355) : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF8B7355)
                          : const Color(0xFFD5C9BB),
                    ),
                  ),
                  child: Text(
                    opt,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : const Color(0xFF9B8E7E),
                      letterSpacing: 0.5,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          _sectionLabel('상자당 최대 의류 수'),
          const SizedBox(height: 12),
          Container(
            color: const Color(0xFFFFFBF7),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                _stepBtn(Icons.remove, () {
                  if (_maxPerBox > 1) setState(() => _maxPerBox--);
                }),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_maxPerBox',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C2416),
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                  ),
                ),
                _stepBtn(Icons.add, () {
                  if (_maxPerBox < 50) setState(() => _maxPerBox++);
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '옷의 평균 부피를 고려해 상자가 너무 많아지지 않도록 적절히 설정하세요.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFFBBAA95),
              height: 1.5,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.inter(fontSize: 12, color: Colors.redAccent).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
          ],
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _analyze,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2C2416),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                'AI 분석 시작',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  color: Colors.white,
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Color(0xFF8B7355),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'AI가 의류를 분석하는 중...',
            style: GoogleFonts.cormorant(
              fontSize: 18,
              color: const Color(0xFF2C2416),
              fontWeight: FontWeight.w600,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          const SizedBox(height: 8),
          Text(
            '${_criteria.join(" · ")} 기준으로 분류 중',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF9B8E7E),
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
        ],
      ),
    );
  }

  // source → { destinationName → [clothes] }
  Map<String, Map<String, List<Cloth>>> _buildFlowData() {
    final result = <String, Map<String, List<Cloth>>>{};
    for (final group in _groups) {
      for (final cloth in _allClothes.where((c) => group.clothIds.contains(c.id))) {
        final from = cloth.storageName ?? '미분류';
        result.putIfAbsent(from, () => {});
        result[from]!.putIfAbsent(group.name, () => []);
        result[from]![group.name]!.add(cloth);
      }
    }
    return result;
  }

  Widget _buildResults() {
    final flowData = _buildFlowData();
    final totalClothes = _groups.fold<int>(0, (s, g) => s + g.clothIds.length);
    final sourceNames = flowData.keys.toList();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            children: [
              // ── 상단 요약 헤더 ──
              Container(
                color: const Color(0xFF1C1510),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI 정리 계획',
                            style: GoogleFonts.cormorant(
                              fontSize: 13, fontWeight: FontWeight.w600,
                              letterSpacing: 3, color: const Color(0xFF8B7355),
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '총 $totalClothes개 의류  →  ${_groups.length}개 새 보관함',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18, fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '기준: ${_criteria.join(" · ")}  ·  상자당 최대 ${_maxPerBox}개',
                            style: GoogleFonts.inter(
                              fontSize: 11, color: const Color(0xFF6B5E50),
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _phase = _Phase.settings),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF8B7355)),
                        ),
                        child: Text(
                          '다시 설정',
                          style: GoogleFonts.inter(
                            fontSize: 10, color: const Color(0xFF8B7355),
                            fontWeight: FontWeight.w600, letterSpacing: 1,
                          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── 흐름 카드: 출발 보관함 기준 ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Text(
                  'MOVE FLOW',
                  style: GoogleFonts.cormorant(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    letterSpacing: 3, color: const Color(0xFF8B7355),
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
              ),
              const SizedBox(height: 12),
              ...sourceNames.map((sourceName) =>
                _buildFlowCard(sourceName, flowData[sourceName]!)),
            ],
          ),
        ),

        // ── 하단 APPLY ──
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFBF7),
            border: Border(top: BorderSide(color: Color(0xFFE8E0D5))),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Text(
                  '새 보관함이 생성되고 의류가 이동됩니다.\n기존 보관함은 그대로 유지됩니다.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11, color: const Color(0xFFBBAA95), height: 1.5,
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _applying ? null : _apply,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF8B7355),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: _applying
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            'APPLY',
                            style: GoogleFonts.inter(
                              fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 3,
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 출발 보관함 1개 → 여러 도착 보관함 흐름 카드
  Widget _buildFlowCard(String sourceName, Map<String, List<Cloth>> destinations) {
    final totalCount = destinations.values.fold<int>(0, (s, l) => s + l.length);
    final destNames = destinations.keys.toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E0D5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 출발 보관함 헤더
          Container(
            color: const Color(0xFF2C2416),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF8B7355)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sourceName,
                    style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  color: const Color(0xFF8B7355),
                  child: Text(
                    '$totalCount개 이동',
                    style: GoogleFonts.inter(
                      fontSize: 10, fontWeight: FontWeight.w600,
                      color: Colors.white, letterSpacing: 0.5,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ),
              ],
            ),
          ),

          // 도착 보관함별 흐름 블록
          ...destNames.asMap().entries.map((entry) {
            final isLast = entry.key == destNames.length - 1;
            final destName = entry.value;
            final clothes = destinations[destName]!;
            return _buildDestinationBlock(destName, clothes, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildDestinationBlock(String destName, List<Cloth> clothes, bool isLast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 화살표 + 도착 보관함 이름
        Container(
          color: const Color(0xFFFFFBF7),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                color: const Color(0xFFF0EAE0),
                child: const Icon(Icons.arrow_downward, size: 14, color: Color(0xFF8B7355)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destName,
                      style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C2416),
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                    Text(
                      '${clothes.length}개',
                      style: GoogleFonts.inter(
                        fontSize: 10, color: const Color(0xFF9B8E7E),
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF8B7355)),
                ),
                child: Text(
                  'NEW',
                  style: GoogleFonts.inter(
                    fontSize: 9, fontWeight: FontWeight.w700,
                    letterSpacing: 1.5, color: const Color(0xFF8B7355),
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
              ),
            ],
          ),
        ),

        // 옷 썸네일 가로 스크롤
        Container(
          color: const Color(0xFFF7F3EE),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: clothes.map((cloth) => _buildClothTile(cloth)).toList(),
            ),
          ),
        ),

        if (!isLast)
          const Divider(height: 1, color: Color(0xFFE8E0D5)),
      ],
    );
  }

  Widget _buildClothTile(Cloth cloth) {
    return Container(
      width: 64,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            color: const Color(0xFFEDE7DD),
            child: cloth.photoUrl != null
                ? Image.network(
                    cloth.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.checkroom, size: 22, color: Color(0xFFBBAA95),
                    ),
                  )
                : const Icon(Icons.checkroom, size: 22, color: Color(0xFFBBAA95)),
          ),
          const SizedBox(height: 4),
          Text(
            cloth.name ?? '이름 없음',
            style: GoogleFonts.inter(
              fontSize: 9, color: const Color(0xFF2C2416),
              fontWeight: FontWeight.w500,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _sectionLabel(String text) => Text(
        text,
        style: GoogleFonts.cormorant(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: const Color(0xFF8B7355),
        ).copyWith(fontFamilyFallback: const ['ChosunSm']),
      );

  Widget _stepBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: const Color(0xFF8B7355)),
        ),
      );
}
