import 'dart:typed_data';
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
  final _memoCtrl = TextEditingController();
  final _clothRepo = ClothRepository();
  final _storageRepo = StorageRepository();
  Uint8List? _photoBytes;
  String _contentType = 'image/jpeg';
  List<Tag> _tags = [];
  bool _loading = false;
  bool _analyzingAI = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  Future<void> _showPhotoOptions() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('카메라로 찍기'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('갤러리에서 가져오기'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    await _pickPhoto(source);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final xf = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (xf == null) return;
    final bytes = await xf.readAsBytes();
    final mime = xf.mimeType ?? 'image/jpeg';
    setState(() {
      _photoBytes = bytes;
      _contentType = mime;
      _analyzingAI = true;
      _tags = [];
    });
    try {
      final result = await AiTagService().analyze(bytes, contentType: mime);
      if (mounted) {
        setState(() => _tags = result.tags);
        if (result.name != null && _nameCtrl.text.isEmpty) {
          _nameCtrl.text = result.name!;
        }
      }
    } finally {
      if (mounted) setState(() => _analyzingAI = false);
    }
  }

  void _removeTag(Tag tag) => setState(() => _tags.remove(tag));

  Future<void> _save() async {
    if (_isSaving || _photoBytes == null) return;
    _isSaving = true;
    setState(() => _loading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await Supabase.instance.client.storage
          .from('clothes-photos')
          .uploadBinary(
            path,
            _photoBytes!,
            fileOptions: FileOptions(contentType: _contentType),
          );
      final photoUrl = Supabase.instance.client.storage
          .from('clothes-photos')
          .getPublicUrl(path);
      final orgId = await _storageRepo.getOrCreateOrgId();
      await _clothRepo.create(
        storageId: widget.storageId,
        orgId: orgId,
        photoUrl: photoUrl,
        name: _nameCtrl.text.isEmpty ? null : _nameCtrl.text,
        memo: _memoCtrl.text.isEmpty ? null : _memoCtrl.text,
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
      _isSaving = false;
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('옷 추가')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _loading ? null : _showPhotoOptions,
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _photoBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  Image.memory(_photoBytes!, fit: BoxFit.cover),
                            )
                          : const Center(
                              child:
                                  Icon(Icons.camera_alt_outlined, size: 48),
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
                                deleteIcon:
                                    const Icon(Icons.close, size: 14),
                                onDeleted: () => _removeTag(t),
                                backgroundColor: t.aiGenerated
                                    ? Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer
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
                  const SizedBox(height: 12),
                  TextField(
                    controller: _memoCtrl,
                    decoration: const InputDecoration(labelText: '메모 (선택)'),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: (_loading || _analyzingAI || _photoBytes == null) ? null : _save,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('저장'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
