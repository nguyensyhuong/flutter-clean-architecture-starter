import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../../../home/presentation/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@clean.dev');
  final _passwordController = TextEditingController(text: '123456');
  bool _navigatedToHome = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final colors = Theme.of(context).colorScheme;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.user == null) {
        _navigatedToHome = false;
        return;
      }

      if (previous?.user == null && !_navigatedToHome) {
        _navigatedToHome = true;
        final user = next.user!;
        final navigator = Navigator.of(context);

        Future<void>.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) {
            return;
          }

          final currentState = ref.read(authControllerProvider);
          if (currentState.user?.id != user.id) {
            return;
          }

          navigator.pushReplacement(
            MaterialPageRoute<void>(builder: (_) => HomePage(user: user)),
          );
        });
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundArt(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1040),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 860;
                      final isCompact = constraints.maxWidth < 520;

                      final hero = _HeroPanel(
                        colorScheme: colors,
                        isCompact: isCompact,
                      );
                      final card = _LoginCard(
                        state: state,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        formKey: _formKey,
                        onSubmit: _submit,
                        onSignOut: () =>
                            ref.read(authControllerProvider.notifier).signOut(),
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 5, child: hero),
                            const SizedBox(width: 24),
                            Expanded(flex: 4, child: card),
                          ],
                        );
                      }

                      return Column(
                        children: [hero, const SizedBox(height: 20), card],
                      );
                    },
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

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.colorScheme, required this.isCompact});

  final ColorScheme colorScheme;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEEF4FF), Color(0xFFF9FBFF), Color(0xFFEAF2FF)],
        ),
        border: Border.all(color: const Color(0xFFDDE7F5)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(29, 78, 216, 0.08),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFDDE7F5)),
              ),
              child: Text(
                'Clean Architecture',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: isCompact ? 13 : 15,
                ),
              ),
            ),
          ),
          SizedBox(height: isCompact ? 18 : 20),
          Text(
            AppStrings.loginTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isCompact ? 38 : 54,
              fontWeight: FontWeight.w900,
              height: 0.96,
              letterSpacing: isCompact ? -1.0 : -1.6,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.state,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onSubmit,
    required this.onSignOut,
  });

  final AuthState state;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final Future<void> Function() onSubmit;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF6F9FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(15, 23, 42, 0.08),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.9),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE7EDF7)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade500,
                              Colors.cyan.shade400,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Use the demo credentials below.',
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: emailController,
                    label: AppStrings.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.emptyEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: passwordController,
                    label: AppStrings.passwordLabel,
                    obscureText: true,
                    prefixIcon: Icons.password_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.emptyPassword;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: state.isLoading ? null : onSubmit,
                      icon: state.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.arrow_forward_rounded),
                      label: Text(
                        state.isLoading ? 'Signing in...' : AppStrings.signIn,
                      ),
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFB91C1C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (state.user != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.successTitle,
                            style: TextStyle(
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${state.user!.name} • ${state.user!.email}',
                            style: const TextStyle(color: Color(0xFF166534)),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: onSignOut,
                            child: const Text(AppStrings.signOut),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'Demo credentials: demo@clean.dev / 123456',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundArt extends StatelessWidget {
  const _BackgroundArt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFFF4F7FB)),
        Positioned(
          top: -120,
          left: -100,
          child: _Blob(
            size: 280,
            colors: [const Color(0xFFBFDBFE), const Color(0xFFDBEAFE)],
          ),
        ),
        Positioned(
          bottom: -100,
          right: -70,
          child: _Blob(
            size: 220,
            colors: [const Color(0xFFFBCFE8), const Color(0xFFFDE68A)],
          ),
        ),
        Positioned(
          top: 180,
          right: 20,
          child: _FloatingNote(
            label: 'Scalable',
            icon: Icons.auto_awesome_rounded,
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors),
      ),
    );
  }
}

class _FloatingNote extends StatelessWidget {
  const _FloatingNote({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.65),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
