import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../main_navigation/main_navigation_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
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
                        // Background Photo
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            'assets/images/login_header_bg.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Dark/Grey transparent overlay
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                        // Back Button
                        Positioned(
                          top: 40,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        // White Logo Container
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
                            l10n.signUpTitle, 
                            style: const TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 22, // Reduced from 24
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4), // Reduced from 6
                          // Subtitle
                          Text(
                            l10n.signUpSubtitle,
                            style: const TextStyle(
                              fontFamily: 'SF Compact',
                              fontSize: 14, // Reduced from 16
                              color: Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16), // Reduced from 24

                          // Full Name Field
                          CustomTextField(
                            controller: _nameController,
                            hintText: l10n.fullName, // Added to ARB
                            keyboardType: TextInputType.name,
                            prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.nameRequired; // Added to ARB
                              }
                              // Requirement: Full name (capital first letter)
                              if (value[0] != value[0].toUpperCase()) {
                                return l10n.nameMustStartWithCapital; // Added to ARB
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

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
                          const SizedBox(height: 12),

                          // Confirm Password Field
                          CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: l10n.confirmPassword, // Added to ARB
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.confirmPasswordRequired; // Added to ARB
                              }
                              if (value != _passwordController.text) {
                                return l10n.passwordsDoNotMatch; // Added to ARB
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Sign Up Button
                          CustomButton(
                            text: l10n.signUp,
                            isLoading: isLoading,
                            onPressed: () => _onSignUpPressed(context),
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

                          // Login Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.alreadyHaveAccount, // Added to ARB
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Go back to login
                                },
                                child: Text(
                                  l10n.login,
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
