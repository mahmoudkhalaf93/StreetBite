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
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                MaterialPageRoute(builder: (_) => const HomeScreen()),
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
                    height: size.height * 0.24, // Reduced from 0.28 to fit small screens perfectly
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
                        // Dark/Grey transparent overlay for better logo visibility
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black.withValues(alpha: 0.3),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Reduced vertical padding
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
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          // Subtitle
                          Text(
                            l10n.signInToGetMeal,
                            style: const TextStyle(
                              fontFamily: 'SF Compact',
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24), // Reduced from 32

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
                          const SizedBox(height: 12), // Reduced from 16

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
                              onPressed: () {},
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
                          const SizedBox(height: 16), // Reduced from 24

                          // Login Button
                          CustomButton(
                            text: l10n.login,
                            isLoading: isLoading,
                            onPressed: () => _onLoginPressed(context),
                          ),
                          const SizedBox(height: 16), // Reduced from 24

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
                          const SizedBox(height: 16), // Reduced from 24

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
                          const SizedBox(height: 12), // Reduced from 16

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
                          const SizedBox(height: 16), // Reduced from 32

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
                                  // Navigate to SignUpScreen
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

