import 'package:flutter/material.dart';
import '../../data/models/storage_location.dart';

class StorageCard extends StatelessWidget {
  final StorageLocation storage;
  final VoidCallback onTap;

  const StorageCard({super.key, required this.storage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: storage.photoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  storage.photoUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.inventory_2_outlined, size: 32),
        title: Text(
          storage.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
