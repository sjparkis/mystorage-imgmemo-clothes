import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/models/storage_location.dart';
import '../../data/models/location.dart';
import '../../l10n/app_localizations.dart';

class AddStorageScreen extends StatefulWidget {
  final StorageLocation? existing;
  const AddStorageScreen({super.key, this.existing});
  @override
  State<AddStorageScreen> createState() => _AddStorageScreenState();
}

class _AddStorageScreenState extends State<AddStorageScreen> {
  final _nameCtrl = TextEditingController();
  final _repo = StorageRepository();
  final _locationRepo = LocationRepository();
  Uint8List? _photoBytes;
  bool _loading = false;
  List<Location> _locations = [];
  Location? _selectedLocation;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _nameCtrl.text = widget.existing!.name;
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final list = await _locationRepo.fetchAll();
    if (!mounted) return;
    setState(() {
      _locations = list;
      if (_isEdit && widget.existing!.locationId != null) {
        _selectedLocation = list.where((l) => l.id == widget.existing!.locationId).firstOrNull;
      }
    });
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFFBF7),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Text(
                'LOCATION',
                style: GoogleFonts.cormorant(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: const Color(0xFF8B7355),
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: const Icon(Icons.close, size: 18, color: Color(0xFFBBAA95)),
              title: Text(
                AppLocalizations.of(ctx).noLocationTag,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF9B8E7E),
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
              trailing: _selectedLocation == null
                  ? const Icon(Icons.check, size: 16, color: Color(0xFF8B7355))
                  : null,
              onTap: () {
                setState(() => _selectedLocation = null);
                Navigator.pop(ctx);
              },
            ),
            const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
            ..._locations.map((loc) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: const Icon(Icons.place_outlined, size: 18, color: Color(0xFF8B7355)),
                  title: Text(
                    loc.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF2C2416),
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                  trailing: _selectedLocation?.id == loc.id
                      ? const Icon(Icons.check, size: 16, color: Color(0xFF8B7355))
                      : null,
                  onTap: () {
                    setState(() => _selectedLocation = loc);
                    Navigator.pop(ctx);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _showPhotoOptions() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFFFFFBF7),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: Color(0xFF8B7355)),
              title: Text(AppLocalizations.of(context).takePhoto,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm'])),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const Divider(height: 1, color: Color(0xFFE8E0D5)),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: Color(0xFF8B7355)),
              title: Text(AppLocalizations.of(context).fromGallery,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm'])),
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
          locationId: _selectedLocation?.id,
        );
      } else {
        await _repo.create(
          name: _nameCtrl.text,
          photoUrl: photoUrl,
          locationId: _selectedLocation?.id,
        );
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
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF2C2416)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEdit ? 'EDIT STORAGE' : 'NEW STORAGE',
          style: GoogleFonts.cormorant(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: const Color(0xFF2C2416),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E0D5)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _showPhotoOptions,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: const Color(0xFFEDE7DD),
                      child: _photoBytes != null
                          ? Image.memory(_photoBytes!, fit: BoxFit.cover)
                          : existingPhotoUrl != null
                              ? Image.network(existingPhotoUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.camera_alt_outlined,
                                        size: 32, color: Color(0xFFBBAA95)),
                                    const SizedBox(height: 8),
                                    Text(
                                      'ADD PHOTO',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2,
                                        color: const Color(0xFFBBAA95),
                                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameCtrl,
                    style: GoogleFonts.inter(
                        fontSize: 14, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).storageName),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showLocationPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFE8E0D5))),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 18, color: Color(0xFF8B7355)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedLocation?.name ?? AppLocalizations.of(context).locationOptional,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: _selectedLocation != null
                                    ? const Color(0xFF2C2416)
                                    : const Color(0xFFBBAA95),
                              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18, color: Color(0xFFBBAA95)),
                        ],
                      ),
                    ),
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
                height: 54,
                child: FilledButton(
                  onPressed: _loading ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8B7355),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'SAVE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
