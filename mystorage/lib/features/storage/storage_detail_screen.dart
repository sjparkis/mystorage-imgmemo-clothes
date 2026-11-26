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
  late Future<(StorageLocation, List<Cloth>)> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() {
        _future = Future.wait([
          _storageRepo.fetchById(widget.storageId),
          _clothRepo.fetchByStorage(widget.storageId),
        ]).then((r) => (r[0] as StorageLocation, r[1] as List<Cloth>));
      });

  Future<void> _togglePresence(Cloth cloth) async {
    // null(미확인) → true(있음) → false(없음) → null 순환
    final next = cloth.isPresent == null
        ? true
        : cloth.isPresent == true
            ? false
            : null;
    await _clothRepo.updatePresence(cloth.id, next);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(StorageLocation, List<Cloth>)>(
      future: _future,
      builder: (ctx, snap) {
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(AppLocalizations.of(ctx).loadError(snap.error.toString()), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _reload, child: Text(AppLocalizations.of(ctx).retry)),
                ],
              ),
            ),
          );
        }
        if (!snap.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F3EE),
            body: Center(
              child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF8B7355)),
            ),
          );
        }
        final (storage, clothes) = snap.data!;
        return Scaffold(
          backgroundColor: const Color(0xFFF7F3EE),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F3EE),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF2C2416)),
              onPressed: () => context.pop(),
            ),
            title: Text(
              storage.name,
              style: GoogleFonts.cormorant(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: const Color(0xFF2C2416),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF2C2416)),
                onPressed: () async {
                  final updated = await context.push<bool>(
                    '/storage/edit/${storage.id}',
                    extra: storage,
                  );
                  if (updated == true) _reload();
                },
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
          body: clothes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.checkroom, size: 44, color: Color(0xFFD5C9BB)),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context).addClothHint,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF9B8E7E),
                        ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: clothes.length,
                  itemBuilder: (_, i) => _ClothCard(
                    cloth: clothes[i],
                    onTogglePresence: () => _togglePresence(clothes[i]),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await context.push('/cloth/add/${widget.storageId}');
              _reload();
            },
            backgroundColor: const Color(0xFF8B7355),
            foregroundColor: Colors.white,
            elevation: 0,
            child: const Icon(Icons.add, size: 20),
          ),
        );
      },
    );
  }
}

class _ClothCard extends StatelessWidget {
  final Cloth cloth;
  final VoidCallback onTogglePresence;

  const _ClothCard({required this.cloth, required this.onTogglePresence});

  @override
  Widget build(BuildContext context) {
    final isPresent = cloth.isPresent;
    final isMissing = isPresent == false;

    return GestureDetector(
      onTap: () => context.push('/cloth/${cloth.id}'),
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
                // 없음일 때 중앙 안내 오버레이
                if (isMissing)
                  Container(color: Colors.black.withValues(alpha: 0.08)),
                // 존재 여부 토글 버튼 (우측 하단)
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
          Row(
            children: [
              Expanded(
                child: Text(
                  cloth.name ?? AppLocalizations.of(context).noName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isMissing
                        ? const Color(0xFFBBAA95)
                        : const Color(0xFF2C2416),
                    letterSpacing: 0.2,
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
