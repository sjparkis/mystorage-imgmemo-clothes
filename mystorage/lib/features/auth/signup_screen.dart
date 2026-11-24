import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111111)),
          onPressed: () => context.pop(),
        ),
        title: const Text('회원가입'),
      ),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '이메일과 비밀번호를 입력해 주세요',
                  style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF111111)),
                  decoration: const InputDecoration(labelText: '이메일'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pwCtrl,
                  obscureText: true,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF111111)),
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    helperText: '6자 이상 입력해 주세요',
                    helperStyle: TextStyle(fontSize: 11, color: Color(0xFF999999)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pwConfirmCtrl,
                  obscureText: true,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF111111)),
                  decoration: const InputDecoration(labelText: '비밀번호 확인'),
                ),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) => FilledButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_pwCtrl.text != _pwConfirmCtrl.text) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
                              );
                              return;
                            }
                            ctx.read<AuthBloc>().add(
                                  AuthSignUp(_emailCtrl.text, _pwCtrl.text),
                                );
                          },
                    child: state is AuthLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
