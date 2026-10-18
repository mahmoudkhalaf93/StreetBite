import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main_navigation/main_navigation_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  Future<void> _onBiometricSignInPressed(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final authCubit = context.read<AuthCubit>();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final prefs = await SharedPreferences.getInstance();
    final isBiometricEnabled = prefs.getBool('BIOMETRIC_ENABLED') ?? false;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (!isBiometricEnabled && currentUser == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'يرجى تسجيل الدخول أولاً وتفعيل "تسجيل الدخول بالبصمة" من صفحة الإعدادات/البروفايل'
                : 'Please log in first and enable "Biometric Login" in Settings/Profile',
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = canCheck || await _localAuth.isDeviceSupported();

      if (!isSupported) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              isArabic
                  ? 'بصمة الأصبع غير مدعومة على هذا الجهاز'
                  : 'Biometric authentication is not supported on this device',
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final bool didAuth = await _localAuth.authenticate(
        localizedReason: isArabic
            ? 'يرجى تأكيد البصمة لتسجيل الدخول إلى StreetBite'
            : 'Please authenticate to sign in to StreetBite',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (didAuth) {
        if (currentUser != null) {
          nav.pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        } else if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
          authCubit.login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          nav.pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Biometric Login Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onGoogleSignInPressed(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _onFacebookSignInPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.underConstruction),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header with Background and Logo
                  SizedBox(
                    height: size.height * 0.24,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            'assets/images/login_header_bg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            'assets/images/applogofastfood.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title
                          Text(
                            l10n.foodAndGroceries,
                            style: const TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          // Subtitle
                          Text(
                            l10n.signInToGetMeal,
                            style: const TextStyle(
                              fontFamily: 'SF Compact',
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          CustomTextField(
                            controller: _emailController,
                            hintText: l10n.emailAddress,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF9CA3AF)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.emailRequired;
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
                                return l10n.emailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Password Field
                          CustomTextField(
                            controller: _passwordController,
                            hintText: l10n.password,
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.passwordRequired;
                              }
                              if (value.length < 6) {
                                return l10n.passwordTooShort;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // Forgot Password
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                l10n.forgotPassword,
                                style: const TextStyle(
                                  fontFamily: 'SF Compact Display',
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Login Button
                          CustomButton(
                            text: l10n.login,
                            isLoading: isLoading,
                            onPressed: () => _onLoginPressed(context),
                          ),
                          const SizedBox(height: 12),

                          // Biometric Fingerprint Button
                          CustomButton(
                            text: isArabic ? 'تسجيل الدخول بالبصمة' : 'Sign In with Fingerprint',
                            backgroundColor: Colors.white,
                            textColor: AppColors.primary,
                            border: const BorderSide(color: AppColors.primary),
                            icon: const Icon(Icons.fingerprint_rounded, color: AppColors.primary, size: 24),
                            onPressed: () => _onBiometricSignInPressed(context),
                          ),
                          const SizedBox(height: 16),

                          // OR Divider
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  l10n.or,
                                  style: const TextStyle(color: Color(0xFF9CA3AF)),
                                ),
                              ),
                              const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Google Button
                          CustomButton(
                            text: l10n.continueWithGoogle,
                            backgroundColor: Colors.white,
                            textColor: const Color(0xFF121212),
                            border: const BorderSide(color: Color(0xFFE5E7EB)),
                            icon: SvgPicture.asset(
                              'assets/images/Google.svg',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: () => _onGoogleSignInPressed(context),
                          ),
                          const SizedBox(height: 12),

                          // Facebook Button
                          CustomButton(
                            text: l10n.continueWithFacebook,
                            backgroundColor: const Color(0xFF3B82F6),
                            textColor: Colors.white,
                            icon: SvgPicture.asset(
                              'assets/images/Facebook.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                            onPressed: () => _onFacebookSignInPressed(context),
                          ),
                          const SizedBox(height: 16),

                          // Sign Up Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.dontHaveAccount,
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                                  );
                                },
                                child: Text(
                                  l10n.signUp,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
