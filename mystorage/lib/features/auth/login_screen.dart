import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();
  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _showForm = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1510),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthSuccess) ctx.go('/');
          if (state is AuthFailure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _showForm
              ? _buildForm(context)
              : _buildIntro(context),
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      key: const ValueKey('intro'),
      children: [
        // 배경 그라데이션 (에디토리얼 느낌)
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2A1F14),
                Color(0xFF1C1510),
                Color(0xFF0E0B08),
              ],
              stops: [0, 0.5, 1],
            ),
          ),
        ),
        // 장식 원
        Positioned(
          top: -size.height * 0.15,
          right: -size.width * 0.2,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF8B7355).withValues(alpha: 0.15),
                width: 1,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.15,
          left: -size.width * 0.3,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF8B7355).withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
        ),
        // 콘텐츠
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),
                Text(
                  'MY',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 72,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 0.9,
                    letterSpacing: -2,
                  ),
                ),
                Text(
                  'STORAGE',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 72,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8B7355),
                    height: 0.9,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 40,
                  height: 1,
                  color: const Color(0xFF8B7355),
                ),
                const SizedBox(height: 20),
                Text(
                  '나만의 옷 보관함',
                  style: GoogleFonts.cormorant(
                    fontSize: 16,
                    color: const Color(0xFF9B8E7E),
                    letterSpacing: 2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(flex: 3),
                GestureDetector(
                  onTap: () => setState(() => _showForm = true),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    color: const Color(0xFF8B7355),
                    alignment: Alignment.center,
                    child: Text(
                      'ENTER',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                        color: const Color(0xFFFFFBF7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/signup'),
                    child: Text(
                      '처음이신가요?  회원가입',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF6B5E50),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      key: const ValueKey('form'),
      children: [
        // 헤더
        Container(
          width: double.infinity,
          color: const Color(0xFF1C1510),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MYSTORAGE',
                    style: GoogleFonts.cormorant(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                      color: const Color(0xFF8B7355),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome\nBack.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 폼 영역
        Expanded(
          child: Container(
            color: const Color(0xFFF7F3EE),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 36, 32, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF2C2416)),
                    decoration: const InputDecoration(labelText: '이메일'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pwCtrl,
                    obscureText: true,
                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF2C2416)),
                    decoration: const InputDecoration(labelText: '비밀번호'),
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (ctx, state) => SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () => ctx.read<AuthBloc>().add(
                                  AuthSignIn(_emailCtrl.text, _pwCtrl.text),
                                ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF8B7355),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'LOGIN',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFE8E0D5))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: const Color(0xFF9B8E7E),
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFE8E0D5))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => context.push('/signup'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2C2416),
                        side: const BorderSide(color: Color(0xFFE8E0D5)),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                      child: Text(
                        '회원가입',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _showForm = false),
                      child: Text(
                        '← 돌아가기',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF9B8E7E),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
