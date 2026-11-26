import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/cloth.dart';
import '../../data/models/tag.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ai_tag_service.dart';

class ClothDetailScreen extends StatefulWidget {
  final String clothId;
  const ClothDetailScreen({super.key, required this.clothId});
  @override
  State<ClothDetailScreen> createState() => _ClothDetailScreenState();
}

class _ClothDetailScreenState extends State<ClothDetailScreen> {
  Cloth? _cloth;
  bool _loading = true;
  bool _analyzing = false;
  final _clothRepo = ClothRepository();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final row = await Supabase.instance.client
          .from('clothes')
          .select('*, storages(name), clothes_tags(ai_generated, tags(id, name, category))')
          .eq('id', widget.clothId)
          .single();
      if (mounted) setState(() { _cloth = Cloth.fromMap(row); _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reanalyze() async {
    if (_cloth?.photoUrl == null) return;
    setState(() => _analyzing = true);
    try {
      final result = await AiTagService().analyzeUrl(_cloth!.photoUrl!);
      if (result.tags.isNotEmpty || result.name != null) {
        await _clothRepo.updateNameAndTags(
          widget.clothId,
          name: result.name,
          tags: result.tags,
        );
        await _load();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).aiAnalyzeDone)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).analyzeError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      );
    }
    if (_cloth == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(AppLocalizations.of(context).clothLoadError)),
      );
    }
    final cloth = _cloth!;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: const Color(0xFF1C1510),
            foregroundColor: Colors.white,
            actions: [
              if (_cloth?.photoUrl != null)
                _analyzing
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        tooltip: AppLocalizations.of(context).aiReanalyze,
                        onPressed: _reanalyze,
                      ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: cloth.photoUrl != null
                  ? Image.network(cloth.photoUrl!, fit: BoxFit.cover)
                  : Container(
                      color: const Color(0xFFEDE7DD),
                      child: const Center(
                        child: Icon(Icons.checkroom, size: 64, color: Color(0xFFBBAA95)),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cloth.storageName != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 14, color: Color(0xFF8B7355)),
                        const SizedBox(width: 6),
                        Text(
                          cloth.storageName!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF8B7355),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    cloth.name ?? AppLocalizations.of(context).noName,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C2416),
                      height: 1.2,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                  if (cloth.createdAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(cloth.createdAt!),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF9B8E7E),
                        letterSpacing: 0.5,
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                  ],
                  if (cloth.tags.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFE8E0D5)),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).aiAnalysis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: const Color(0xFF9B8E7E),
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                    const SizedBox(height: 14),
                    ..._buildTagGroups(cloth.tags, AppLocalizations.of(context)),
                  ],
                  if (cloth.memo != null && cloth.memo!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFE8E0D5)),
                    const SizedBox(height: 16),
                    Text(
                      'MEMO',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: const Color(0xFF9B8E7E),
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cloth.memo!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF2C2416),
                        height: 1.6,
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _categoryOrder = [
    'type', 'color', 'material', 'season', 'style', 'condition', 'brand', 'custom'
  ];

  String _catLabel(String cat, AppLocalizations l10n) => switch (cat) {
    'color' => l10n.tagColor,
    'type' => l10n.tagType,
    'material' => l10n.tagMaterial,
    'season' => l10n.tagSeason,
    'style' => l10n.tagStyle,
    'condition' => l10n.tagCondition,
    'brand' => l10n.tagBrand,
    'custom' => l10n.tagOther,
    _ => cat,
  };

  List<Widget> _buildTagGroups(List<Tag> tags, AppLocalizations l10n) {
    final grouped = <String, List<Tag>>{};
    for (final t in tags) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }
    final widgets = <Widget>[];
    for (final cat in _categoryOrder) {
      if (!grouped.containsKey(cat)) continue;
      final label = _catLabel(cat, l10n);
      final catTags = grouped[cat]!;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF9B8E7E),
                    fontWeight: FontWeight.w500,
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: catTags.map((t) => _TagChip(tag: t)).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} 등록';
  }
}

class _TagChip extends StatelessWidget {
  final Tag tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tag.aiGenerated ? const Color(0xFFF0E8DC) : const Color(0xFFEDE7DD),
        border: Border.all(color: const Color(0xFFE8E0D5)),
      ),
      child: Text(
        tag.name,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: const Color(0xFF2C2416),
          letterSpacing: 0.5,
        ).copyWith(fontFamilyFallback: const ['ChosunSm']),
      ),
    );
  }
}
