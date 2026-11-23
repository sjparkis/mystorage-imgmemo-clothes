import 'package:flutter/material.dart';
import '../../data/models/cloth.dart';

class ClothDetailScreen extends StatelessWidget {
  final String clothId;
  const ClothDetailScreen({super.key, required this.clothId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('옷 상세')),
      body: Center(child: Text('옷 ID: $clothId')),
    );
  }
}
