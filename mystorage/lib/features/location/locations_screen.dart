import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/location.dart';
import '../../data/repositories/location_repository.dart';
import '../../l10n/app_localizations.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});
  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final _repo = LocationRepository();
  List<Location> _locations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await _repo.fetchAll();
      if (mounted) setState(() { _locations = list; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showAddSheet({Location? editing}) {
    final ctrl = TextEditingController(text: editing?.name ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFBF7),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 32,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              editing == null ? 'NEW LOCATION' : 'EDIT LOCATION',
              style: GoogleFonts.cormorant(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
                color: const Color(0xFF8B7355),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              autofocus: true,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFF2C2416),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
              decoration: InputDecoration(hintText: AppLocalizations.of(ctx).locationNameHint),
              onSubmitted: (_) => _submit(ctx, ctrl.text, editing),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () => _submit(ctx, ctrl.text, editing),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8B7355),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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

  Future<void> _submit(BuildContext ctx, String name, Location? editing) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    Navigator.pop(ctx);
    try {
      if (editing == null) {
        await _repo.create(trimmed);
      } else {
        await _repo.update(editing.id, trimmed);
      }
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).locationSaveFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _delete(Location loc) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBF7),
        title: Text(
          AppLocalizations.of(context).locationDeleteTitle,
          style: GoogleFonts.cormorant(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2416),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        content: Text(
          AppLocalizations.of(context).locationDeleteConfirm(loc.name),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF6B5E50),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF9B8E7E),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context).delete,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFCC5C5C),
              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
            ),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _repo.delete(loc.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF2C2416)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'LOCATIONS',
          style: GoogleFonts.cormorant(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: const Color(0xFF2C2416),
          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22, color: Color(0xFF2C2416)),
            onPressed: () => _showAddSheet(),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E0D5)),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF8B7355)),
            )
          : _locations.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.of(context).locationAddHint,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF9B8E7E),
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                )
              : Container(
                  color: const Color(0xFFFFFBF7),
                  child: ListView.separated(
                    itemCount: _locations.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Color(0xFFE8E0D5),
                      indent: 24,
                      endIndent: 24,
                    ),
                    itemBuilder: (_, i) {
                      final loc = _locations[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        onTap: () => _showAddSheet(editing: loc),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE7DD),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Icon(
                            Icons.place_outlined,
                            size: 18,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                        title: Text(
                          loc.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2C2416),
                          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFBBAA95)),
                          onPressed: () => _delete(loc),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
