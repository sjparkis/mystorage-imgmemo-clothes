import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository()),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();
  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _pwConfirmCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pwConfirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthSuccess) ctx.go('/');
          if (state is AuthEmailVerificationSent) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('인증 이메일을 보냈습니다. 이메일을 확인해 주세요.'),
                duration: Duration(seconds: 5),
              ),
            );
            ctx.go('/login');
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
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
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back,
                            size: 20, color: Color(0xFF8B7355)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'MYSTORAGE',
                        style: GoogleFonts.cormorant(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 4,
                          color: const Color(0xFF8B7355),
                        ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Create\nAccount.',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -1,
                        ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                        style: GoogleFonts.inter(
                            fontSize: 14, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        decoration: const InputDecoration(labelText: '이메일'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _pwCtrl,
                        obscureText: true,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          helperText: '6자 이상 입력해 주세요',
                          helperStyle:
                              TextStyle(fontSize: 11, color: Color(0xFF9B8E7E)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _pwConfirmCtrl,
                        obscureText: true,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: const Color(0xFF2C2416)).copyWith(fontFamilyFallback: const ['ChosunSm']),
                        decoration:
                            const InputDecoration(labelText: '비밀번호 확인'),
                      ),
                      const SizedBox(height: 28),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (ctx, state) => SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_pwCtrl.text != _pwConfirmCtrl.text) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('비밀번호가 일치하지 않습니다.')),
                                      );
                                      return;
                                    }
                                    ctx.read<AuthBloc>().add(
                                          AuthSignUp(
                                              _emailCtrl.text, _pwCtrl.text),
                                        );
                                  },
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
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(
                                    'JOIN',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 3,
                                    ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            '← 로그인으로 돌아가기',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF9B8E7E),
                              letterSpacing: 1,
                            ).copyWith(fontFamilyFallback: const ['ChosunSm']),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
