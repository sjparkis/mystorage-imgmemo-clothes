import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/models/tag.dart';
import '../../services/ai_tag_service.dart';

class AddClothScreen extends StatefulWidget {
  final String storageId;
  const AddClothScreen({super.key, required this.storageId});
  @override
  State<AddClothScreen> createState() => _AddClothScreenState();
}

class _AddClothScreenState extends State<AddClothScreen> {
  final _nameCtrl = TextEditingController();
  final _clothRepo = ClothRepository();
  final _storageRepo = StorageRepository();
  File? _photo;
  List<Tag> _tags = [];
  bool _loading = false;
  bool _analyzingAI = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final xf = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (xf == null) return;
    setState(() {
      _photo = File(xf.path);
      _analyzingAI = true;
    });
    try {
      final path = 'clothes/tmp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await Supabase.instance.client.storage
          .from('clothes-photos')
          .upload(path, _photo!);
      final url = Supabase.instance.client.storage
          .from('clothes-photos')
          .getPublicUrl(path);
      final tags = await AiTagService().analyze(url);
      if (mounted) setState(() => _tags = tags);
    } finally {
      if (mounted) setState(() => _analyzingAI = false);
    }
  }

  void _removeTag(Tag tag) => setState(() => _tags.remove(tag));

  Future<void> _save() async {
    if (_photo == null) return;
    setState(() => _loading = true);
    try {
      final path = 'clothes/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await Supabase.instance.client.storage
          .from('clothes-photos')
          .upload(path, _photo!);
      final photoUrl = Supabase.instance.client.storage
          .from('clothes-photos')
          .getPublicUrl(path);
      final orgId = await _storageRepo.getOrCreateOrgId();
      await _clothRepo.create(
        storageId: widget.storageId,
        orgId: orgId,
        photoUrl: photoUrl,
        name: _nameCtrl.text.isEmpty ? null : _nameCtrl.text,
        tags: _tags,
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('옷 추가'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _loading ? null : _pickPhoto,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_photo!, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Icon(Icons.camera_alt_outlined, size: 48),
                      ),
              ),
            ),
            if (_analyzingAI) ...[
              const SizedBox(height: 12),
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('AI 분석 중...', style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags
                    .map((t) => Chip(
                          label: Text(t.name),
                          deleteIcon: const Icon(Icons.close, size: 14),
                          onDeleted: () => _removeTag(t),
                          backgroundColor: t.aiGenerated
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : null,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '이름 (선택)'),
            ),
          ],
        ),
      ),
    );
  }
}
