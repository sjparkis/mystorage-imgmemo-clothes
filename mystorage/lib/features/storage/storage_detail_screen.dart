import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../data/models/storage_location.dart';
import '../../data/models/cloth.dart';
import '../../l10n/app_localizations.dart';

class StorageDetailScreen extends StatefulWidget {
  final String storageId;
  const StorageDetailScreen({super.key, required this.storageId});
  @override
  State<StorageDetailScreen> createState() => _StorageDetailScreenState();
}

class _StorageDetailScreenState extends State<StorageDetailScreen> {
  final _storageRepo = StorageRepository();
  final _clothRepo = ClothRepository();

  StorageLocation? _storage;
  List<Cloth> _clothes = [];
  bool _loading = true;
  String? _error;

  final Set<String> _selectedIds = {};
  bool _selectMode = false;
  bool get _isSelecting => _selectMode;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        _storageRepo.fetchById(widget.storageId),
        _clothRepo.fetchByStorage(widget.storageId),
      ]);
      if (mounted) {
        setState(() {
          _storage = results[0] as StorageLocation;
          _clothes = results[1] as List<Cloth>;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _togglePresence(Cloth cloth) async {
    final next = cloth.isPresent == null
        ? true
        : cloth.isPresent == true
            ? false
            : null;
    await _clothRepo.updatePresence(cloth.id, next);
    _load();
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _enterSelectMode() => setState(() { _selectMode = true; _selectedIds.clear(); });
  void _clearSelection() => setState(() { _selectMode = false; _selectedIds.clear(); });

  Future<void> _bulkMoveToSystemStorage(String type) async {
    final l10n = AppLocalizations.of(context);
    try {
      final target = await _storageRepo.fetchSystemStorage(type);
      if (target == null) return;
      await Future.wait(_selectedIds.map((id) => _clothRepo.updateStorage(id, target.id)));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.moveDone)),
        );
        _clearSelection();
        _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.moveFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _showBulkMoveSheet() async {
    final l10n = AppLocalizations.of(context);
    List<StorageLocation> storages = [];
    try {
      storages = (await _storageRepo.fetchAll())
          .where((s) => !s.isSystem && s.id != widget.storageId)
          .toList();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFFBF7),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Text(
              l10n.selectStorage,
              style: GoogleFonts.cormorant(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: const Color(0xFF2C2416),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
          ),
          ...storages.map((s) => ListTile(
                title: Text(
                  s.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF2C2416),
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    await Future.wait(
                      _selectedIds.map((id) => _clothRepo.updateStorage(id, s.id)),
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.moveDone)),
                      );
                      _clearSelection();
                      _load();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.moveFailed(e.toString()))),
                      );
                    }
                  }
                },
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final storage = _storage;

    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F3EE),
        body: Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF8B7355))),
      );
    }
    if (_error != null || storage == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.grey),
              const SizedBox(height: 12),
              Text(l10n.loadError(_error ?? ''), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        surfaceTintColor: Colors.transparent,
        leading: _isSelecting
            ? IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF2C2416)),
                onPressed: _clearSelection,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF2C2416)),
                onPressed: () => context.pop(),
              ),
        title: _isSelecting
            ? Text(
                '${_selectedIds.length}개 선택',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2C2416),
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              )
            : Text(
                storage.name,
                style: GoogleFonts.cormorant(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: const Color(0xFF2C2416),
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
        centerTitle: true,
        actions: _isSelecting
            ? []
            : [
                if (!storage.isSystem)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF2C2416)),
                    onPressed: () async {
                      final updated = await context.push<bool>(
                        '/storage/edit/${storage.id}',
                        extra: storage,
                      );
                      if (updated == true) _load();
                    },
                  ),
                if (_clothes.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.checklist_outlined, size: 20, color: Color(0xFF2C2416)),
                    onPressed: _enterSelectMode,
                  ),
                IconButton(
                  icon: const Icon(Icons.qr_code, size: 20, color: Color(0xFF2C2416)),
                  onPressed: () => context.push('/qr-sticker', extra: storage),
                ),
              ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E0D5)),
        ),
      ),
      body: _clothes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.checkroom, size: 44, color: Color(0xFFD5C9BB)),
                  const SizedBox(height: 20),
                  Text(
                    l10n.addClothHint,
                    style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF9B8E7E))
                        .copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(16, 20, 16, _isSelecting ? 120 : 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
              ),
              itemCount: _clothes.length,
              itemBuilder: (_, i) {
                final cloth = _clothes[i];
                return _ClothCard(
                  cloth: cloth,
                  isSelecting: _isSelecting,
                  isSelected: _selectedIds.contains(cloth.id),
                  onTogglePresence: () => _togglePresence(cloth),
                  onTap: () {
                    if (_isSelecting) {
                      _toggleSelect(cloth.id);
                    } else {
                      context.push('/cloth/${cloth.id}').then((_) => _load());
                    }
                  },
                  onLongPress: _isSelecting ? null : _enterSelectMode,
                );
              },
            ),
      bottomNavigationBar: _isSelecting
          ? _BulkActionBar(
              count: _selectedIds.length,
              onMove: _showBulkMoveSheet,
              onTrash: () => _bulkMoveToSystemStorage('trash'),
              onSale: () => _bulkMoveToSystemStorage('for_sale'),
            )
          : null,
      floatingActionButton: _isSelecting
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await context.push('/cloth/add/${widget.storageId}');
                _load();
              },
              backgroundColor: const Color(0xFF8B7355),
              foregroundColor: Colors.white,
              elevation: 0,
              child: const Icon(Icons.add, size: 20),
            ),
    );
  }
}

class _BulkActionBar extends StatelessWidget {
  final int count;
  final VoidCallback onMove;
  final VoidCallback onTrash;
  final VoidCallback onSale;

  const _BulkActionBar({
    required this.count,
    required this.onMove,
    required this.onTrash,
    required this.onSale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2C2416),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        children: [
          Text(
            '$count개',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          const Spacer(),
          _BarButton(icon: Icons.drive_file_move_outlined, label: '이동', onTap: onMove),
          const SizedBox(width: 24),
          _BarButton(icon: Icons.delete_outline, label: '휴지통', onTap: onTrash),
          const SizedBox(width: 24),
          _BarButton(icon: Icons.sell_outlined, label: '판매', onTap: onSale),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BarButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 10, color: Colors.white)
                .copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
        ],
      ),
    );
  }
}

class _ClothCard extends StatelessWidget {
  final Cloth cloth;
  final bool isSelecting;
  final bool isSelected;
  final VoidCallback onTogglePresence;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ClothCard({
    required this.cloth,
    required this.isSelecting,
    required this.isSelected,
    required this.onTogglePresence,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = cloth.isPresent;
    final isMissing = isPresent == false;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: isMissing ? 0.45 : 1.0,
                  child: cloth.photoUrl != null
                      ? Image.network(
                          cloth.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                if (isMissing) Container(color: Colors.black.withValues(alpha: 0.08)),
                if (isSelecting)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    color: isSelected
                        ? const Color(0xFF8B7355).withValues(alpha: 0.35)
                        : Colors.transparent,
                  ),
                if (isSelecting)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color(0xFF8B7355) : Colors.white.withValues(alpha: 0.85),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF8B7355) : const Color(0xFFBBAA95),
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                if (!isSelecting)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: onTogglePresence,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPresent == true
                              ? const Color(0xFF8B7355)
                              : isPresent == false
                                  ? const Color(0xFFCC5C5C)
                                  : Colors.black.withValues(alpha: 0.45),
                        ),
                        child: Text(
                          isPresent == true
                              ? AppLocalizations.of(context).present
                              : isPresent == false
                                  ? AppLocalizations.of(context).absent
                                  : AppLocalizations.of(context).confirmPresent,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cloth.name ?? AppLocalizations.of(context).noName,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isMissing ? const Color(0xFFBBAA95) : const Color(0xFF2C2416),
              letterSpacing: 0.2,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (cloth.tags.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              cloth.tags.take(3).map((t) => t.name).join('  ·  '),
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF9B8E7E),
                letterSpacing: 0.3,
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFEDE7DD),
        child: const Center(
          child: Icon(Icons.checkroom, size: 36, color: Color(0xFFBBAA95)),
        ),
      );
}
