import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/family_repository.dart';
import '../../l10n/app_localizations.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});
  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final _repo = FamilyRepository();
  final _codeCtrl = TextEditingController();

  List<OrgMember> _members = [];
  String? _activeCode;
  bool _loadingMembers = true;
  bool _generatingCode = false;
  bool _joining = false;
  String? _myUserId;

  @override
  void initState() {
    super.initState();
    _myUserId = Supabase.instance.client.auth.currentUser?.id;
    _load();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loadingMembers = true);
    try {
      final results = await Future.wait([
        _repo.fetchMembers(),
        _repo.getActiveInviteCode(),
      ]);
      if (mounted) {
        setState(() {
          _members = results[0] as List<OrgMember>;
          _activeCode = results[1] as String?;
          _loadingMembers = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  Future<void> _generateCode() async {
    setState(() => _generatingCode = true);
    try {
      final code = await _repo.createInviteCode();
      if (mounted) setState(() => _activeCode = code);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).familyCodeCreateFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _generatingCode = false);
    }
  }

  Future<void> _join() async {
    final input = _codeCtrl.text.trim();
    if (input.length < 6) return;
    setState(() => _joining = true);
    try {
      await _repo.joinWithCode(input);
      _codeCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).familyJoined)),
        );
        _load();
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      final msg = e.toString().contains('invalid_or_expired')
          ? l10n.familyInvalidCode
          : e.toString().contains('already_member')
              ? l10n.familyAlreadyMember
              : l10n.familyJoinFailed(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  Future<void> _removeMember(OrgMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBF7),
        title: Text(AppLocalizations.of(ctx).familyRemoveMember, style: GoogleFonts.playfairDisplay(fontSize: 18).copyWith(fontFamilyFallback: const ['ChosunSm'])),
        content: Text(
          AppLocalizations.of(ctx).familyRemoveConfirm(member.email),
          style: GoogleFonts.inter(fontSize: 13).copyWith(fontFamilyFallback: const ['ChosunSm']),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(ctx).cancel, style: GoogleFonts.inter(color: const Color(0xFF9B8E7E)).copyWith(fontFamilyFallback: const ['ChosunSm'])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(ctx).familyRemove, style: GoogleFonts.inter(color: Colors.redAccent).copyWith(fontFamilyFallback: const ['ChosunSm'])),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _repo.removeMember(member.userId);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).familyRemoveFailed(e.toString()))));
      }
    }
  }

  bool get _isOwner =>
      _members.any((m) => m.userId == _myUserId && m.isOwner);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'FAMILY',
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
      body: _loadingMembers
          ? const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 1.5, color: Color(0xFF8B7355)),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMembersSection(),
                  const SizedBox(height: 2),
                  _buildInviteSection(),
                  const SizedBox(height: 2),
                  _buildJoinSection(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
    );
  }

  Widget _buildMembersSection() {
    return Container(
      color: const Color(0xFFFFFBF7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Text(
                  'MEMBERS',
                  style: GoogleFonts.cormorant(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                    color: const Color(0xFF8B7355),
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  color: const Color(0xFF8B7355),
                  child: Text(
                    '${_members.length}',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ),
              ],
            ),
          ),
          ..._members.map((m) => _buildMemberTile(m)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMemberTile(OrgMember member) {
    final isMe = member.userId == _myUserId;
    return Column(
      children: [
        const Divider(height: 1, color: Color(0xFFE8E0D5), indent: 24, endIndent: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: member.isOwner
                      ? const Color(0xFF2C2416)
                      : const Color(0xFFEDE7DD),
                ),
                child: Center(
                  child: Text(
                    member.email.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: member.isOwner
                          ? const Color(0xFF8B7355)
                          : const Color(0xFF8B7355),
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.email,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2C2416),
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                        ),
                        if (isMe)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            color: const Color(0xFFEDE7DD),
                            child: Text(
                              AppLocalizations.of(context).familyRoleMe,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                color: const Color(0xFF8B7355),
                                fontWeight: FontWeight.w700,
                              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.isOwner ? AppLocalizations.of(context).familyRoleOwner : AppLocalizations.of(context).familyRoleMember,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF9B8E7E),
                      ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                    ),
                  ],
                ),
              ),
              if (_isOwner && !isMe)
                GestureDetector(
                  onTap: () => _removeMember(member),
                  child: const Icon(Icons.person_remove_outlined,
                      size: 18, color: Color(0xFFBBAA95)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInviteSection() {
    return Container(
      color: const Color(0xFFFFFBF7),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVITE',
            style: GoogleFonts.cormorant(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: const Color(0xFF8B7355),
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).familyInviteInfo,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF9B8E7E),
              height: 1.5,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          const SizedBox(height: 16),
          if (_activeCode != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE8E0D5)),
                color: const Color(0xFFF7F3EE),
              ),
              child: Column(
                children: [
                  Text(
                    _activeCode!,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C2416),
                      letterSpacing: 6,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).familyCodeExpiry,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF9B8E7E),
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: _activeCode!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppLocalizations.of(context).familyCodeCopied)),
                            );
                          },
                          child: Container(
                            height: 44,
                            color: const Color(0xFF8B7355),
                            alignment: Alignment.center,
                            child: Text(
                              'COPY',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3,
                                color: Colors.white,
                              ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _generatingCode ? null : _generateCode,
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE8E0D5)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).familyNewCode,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF9B8E7E),
                              fontWeight: FontWeight.w500,
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _generatingCode ? null : _generateCode,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2416),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                ),
                child: _generatingCode
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        AppLocalizations.of(context).familyCreateCode,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJoinSection() {
    return Container(
      color: const Color(0xFFFFFBF7),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JOIN',
            style: GoogleFonts.cormorant(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: const Color(0xFF8B7355),
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).familyJoinHint,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF9B8E7E),
              height: 1.5,
            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C2416),
                    letterSpacing: 3,
                  ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  decoration: InputDecoration(
                    hintText: 'ABC-123',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFFD5C9BB),
                      letterSpacing: 2,
                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                  ),
                  onSubmitted: (_) => _join(),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _joining ? null : _join,
                child: Container(
                  width: 70,
                  height: 50,
                  color: const Color(0xFF8B7355),
                  alignment: Alignment.center,
                  child: _joining
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'JOIN',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Colors.white,
                          ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
