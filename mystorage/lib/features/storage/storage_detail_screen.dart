import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: cloth.photoUrl != null
                ? Image.network(
                    cloth.photoUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: Icon(Icons.checkroom, size: 40),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              cloth.name ?? '이름 없음',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
