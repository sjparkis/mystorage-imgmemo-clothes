import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../data/models/storage_location.dart';
import '../../data/models/cloth.dart';

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
                  Text('오류: ${snap.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _reload, child: const Text('다시 시도')),
                ],
              ),
            ),
          );
        }
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final (storage, clothes) = snap.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(storage.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final updated = await context.push<bool>(
                    '/storage/edit/${storage.id}',
                    extra: storage,
                  );
                  if (updated == true) _reload();
                },
              ),
              IconButton(
                icon: const Icon(Icons.qr_code),
                onPressed: () =>
                    context.push('/qr-sticker', extra: storage),
              ),
            ],
          ),
          body: clothes.isEmpty
              ? const Center(child: Text('옷을 추가해 주세요'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: clothes.length,
                  itemBuilder: (_, i) => _ClothCard(cloth: clothes[i]),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await context.push('/cloth/add/${widget.storageId}');
              _reload();
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _ClothCard extends StatelessWidget {
  final Cloth cloth;
  const _ClothCard({required this.cloth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/cloth/${cloth.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: cloth.photoUrl != null
                ? Image.network(
                    cloth.photoUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => _placeholder(context),
                  )
                : _placeholder(context),
          ),
          const SizedBox(height: 8),
          Text(
            cloth.name ?? '이름 없음',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C2416),
              letterSpacing: 0.2,
            ),
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
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        color: const Color(0xFFEDE7DD),
        child: const Center(
          child: Icon(Icons.checkroom, size: 36, color: Color(0xFFBBAA95)),
        ),
      );
}
