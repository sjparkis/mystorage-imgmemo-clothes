import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/models/storage_location.dart';

class AddStorageScreen extends StatefulWidget {
  final StorageLocation? existing;
  const AddStorageScreen({super.key, this.existing});
  @override
  State<AddStorageScreen> createState() => _AddStorageScreenState();
}

class _AddStorageScreenState extends State<AddStorageScreen> {
  final _nameCtrl = TextEditingController();
  final _repo = StorageRepository();
  Uint8List? _photoBytes;
  bool _loading = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _nameCtrl.text = widget.existing!.name;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
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
    final xf = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (xf == null) return;
    final bytes = await xf.readAsBytes();
    setState(() => _photoBytes = bytes);
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      String? photoUrl = _isEdit ? widget.existing!.photoUrl : null;
      if (_photoBytes != null) {
        final userId = Supabase.instance.client.auth.currentUser!.id;
        final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('storage-photos')
            .uploadBinary(path, _photoBytes!);
        photoUrl = Supabase.instance.client.storage
            .from('storage-photos')
            .getPublicUrl(path);
      }
      if (_isEdit) {
        await _repo.update(
          id: widget.existing!.id,
          name: _nameCtrl.text,
          photoUrl: photoUrl,
        );
      } else {
        await _repo.create(name: _nameCtrl.text, photoUrl: photoUrl);
      }
      if (mounted) context.pop(true);
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
    final existingPhotoUrl = widget.existing?.photoUrl;
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? '보관함 편집' : '보관함 추가')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showPhotoOptions,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _photoBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(_photoBytes!, fit: BoxFit.cover),
                      )
                    : existingPhotoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              existingPhotoUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined, size: 40),
                              SizedBox(height: 8),
                              Text('사진 추가'),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '보관함 이름'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
