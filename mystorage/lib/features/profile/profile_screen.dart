import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/locale_cubit.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/cloth_repository.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storageRepo = StorageRepository();
  final _clothRepo = ClothRepository();
  final _nicknameCtrl = TextEditingController();

  int _storageCount = 0;
  int _clothCount = 0;
  bool _loadingStats = true;
  bool _savingProfile = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
    final meta = Supabase.instance.client.auth.currentUser?.userMetadata;
    _nicknameCtrl.text = (meta?['nickname'] as String?) ?? '';
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    try {
      final storages = await _storageRepo.fetchAll();
      int clothTotal = 0;
      for (final s in storages) {
        final clothes = await _clothRepo.fetchByStorage(s.id);
        clothTotal += clothes.length;
      }
      if (mounted) {
        setState(() {
          _storageCount = storages.length;
          _clothCount = clothTotal;
          _loadingStats = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingStats = false);
    }
  }

  Future<void> _pickAvatar() async {
    final xf = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 400,
    );
    if (xf == null) return;
    final bytes = await xf.readAsBytes();
    await _uploadAvatar(bytes);
  }

  Future<void> _uploadAvatar(Uint8List bytes) async {
    setState(() => _savingProfile = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final path = '$userId/avatar.jpg';
      await Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
      final url = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(path);
      // cache-bust
      final avatarUrl = '$url?v=${DateTime.now().millisecondsSinceEpoch}';
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'avatar_url': avatarUrl}),
      );
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profilePhotoFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _saveNickname(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    setState(() => _savingProfile = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'nickname': trimmed}),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profileNicknameFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    StorageRepository.clearCache();
    if (mounted) context.go('/login');
  }

  void _showNicknameSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFBF7),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 32,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NICKNAME',
              style: GoogleFonts.cormorant(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
                color: const Color(0xFF8B7355),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nicknameCtrl,
              autofocus: true,
              style: GoogleFonts.inter(
                  fontSize: 15, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm']),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(ctx).profileNicknameHint,
              ),
              onSubmitted: (v) {
                Navigator.pop(ctx);
                _saveNickname(v);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _saveNickname(_nicknameCtrl.text);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B7355),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                ),
                child: Text(
                  'SAVE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final meta = user?.userMetadata;
    final email = user?.email ?? '';
    final nickname = (meta?['nickname'] as String?) ?? '';
    final avatarUrl = meta?['avatar_url'] as String?;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'MY PAGE',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(email, nickname, avatarUrl),
            const SizedBox(height: 2),
            if (!_loadingStats) _buildStats(),
            const SizedBox(height: 2),
            _buildMenuSection(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: _signOut,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE8E0D5)),
                  ),
                  child: Text(
                    'SIGN OUT',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: const Color(0xFF9B8E7E),
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String email, String nickname, String? avatarUrl) {
    return Container(
      color: const Color(0xFF1C1510),
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: _savingProfile ? null : _pickAvatar,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF8B7355), width: 1),
                    color: const Color(0xFF2A1F14),
                  ),
                  child: ClipOval(
                    child: avatarUrl != null
                        ? Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_outline,
                              color: Color(0xFF8B7355),
                              size: 32,
                            ),
                          )
                        : const Icon(
                            Icons.person_outline,
                            color: Color(0xFF8B7355),
                            size: 32,
                          ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _savingProfile ? null : _pickAvatar,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8B7355),
                      border: Border.all(color: const Color(0xFF1C1510), width: 1.5),
                    ),
                    child: const Icon(Icons.edit, size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'MEMBER',
            style: GoogleFonts.cormorant(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: const Color(0xFF8B7355),
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _showNicknameSheet,
            child: Row(
              children: [
                Text(
                  nickname.isNotEmpty ? nickname : AppLocalizations.of(context).profileNicknameSet,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: nickname.isNotEmpty
                        ? Colors.white
                        : const Color(0xFF6B5E50),
                    letterSpacing: -0.3,
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.edit, size: 13, color: Color(0xFF6B5E50)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B5E50),
              letterSpacing: 0.3,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      color: const Color(0xFFFFFBF7),
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Row(
        children: [
          Expanded(child: _buildStatItem(_storageCount.toString(), AppLocalizations.of(context).profileStorages)),
          Container(width: 1, height: 36, color: const Color(0xFFE8E0D5)),
          Expanded(child: _buildStatItem(_clothCount.toString(), AppLocalizations.of(context).profileClothes)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2416),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF9B8E7E),
            letterSpacing: 1,
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      color: const Color(0xFFFFFBF7),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.inventory_2_outlined,
            label: AppLocalizations.of(context).profileMyStorages,
            onTap: () => context.go('/'),
          ),
          const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
          _buildMenuItem(
            icon: Icons.place_outlined,
            label: AppLocalizations.of(context).profileLocations,
            onTap: () => context.push('/locations'),
          ),
          const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
          _buildMenuItem(
            icon: Icons.people_outline,
            label: AppLocalizations.of(context).profileFamily,
            onTap: () => context.push('/family'),
          ),
          const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
          _buildMenuItem(
            icon: Icons.search_outlined,
            label: AppLocalizations.of(context).profileClothSearch,
            onTap: () => context.push('/search'),
          ),
          const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
          _buildMenuItem(
            icon: Icons.qr_code_outlined,
            label: AppLocalizations.of(context).profileQrScan,
            onTap: () => context.push('/qr-scan'),
          ),
          const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
          _buildLanguageMenuItem(context),
        ],
      ),
    );
  }

  Widget _buildLanguageMenuItem(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (ctx, locale) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.language_outlined, size: 18, color: Color(0xFF8B7355)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.settingsLanguage,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF2C2416),
                  fontWeight: FontWeight.w500,
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ),
            GestureDetector(
              onTap: () => ctx.read<LocaleCubit>().setLocale(const Locale('ko')),
              child: Text(
                '한국어',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: locale.languageCode == 'ko'
                      ? const Color(0xFF8B7355)
                      : const Color(0xFFBBAA95),
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '|',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFD5C9BB)),
              ),
            ),
            GestureDetector(
              onTap: () => ctx.read<LocaleCubit>().setLocale(const Locale('en')),
              child: Text(
                'English',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: locale.languageCode == 'en'
                      ? const Color(0xFF8B7355)
                      : const Color(0xFFBBAA95),
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF8B7355)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF2C2416),
                  fontWeight: FontWeight.w500,
                ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFBBAA95)),
          ],
        ),
      ),
    );
  }
}
