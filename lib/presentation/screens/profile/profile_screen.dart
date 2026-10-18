import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Header
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    String name = "Vlad S."; // Default for design
                    if (state is AuthSuccess) {
                      name = state.user.name.isNotEmpty ? state.user.name : name;
                    }
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.grey.shade300,
                          // For now, hardcode a placeholder or use network image if user has one
                          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),

                // 2. Settings (Expandable to show Language and Theme)
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(isDark ? Colors.white : const Color(0xFF1E1E1E), BlendMode.srcIn),
                    ),
                    title: Text(
                      l10n.settings,
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                      ),
                    ),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 40, right: 16),
                        title: Text(l10n.language, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                        trailing: DropdownButton<String>(
                          value: Localizations.localeOf(context).languageCode,
                          underline: const SizedBox(),
                          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              context.read<LocaleCubit>().toggleLocale();
                            }
                          },
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 40, right: 16),
                        title: Text(l10n.theme, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                        trailing: Switch(
                          activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                          activeThumbColor: AppColors.primary,
                          value: isDark,
                          onChanged: (value) {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Contact Us
                _buildMenuItem(
                  iconPath: 'assets/icons/contact_us.svg',
                  title: l10n.contactUs,
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 16),

                // 4. Help Center
                _buildMenuItem(
                  iconPath: 'assets/icons/help_center.svg',
                  title: l10n.helpCenter,
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 16),

                // 5. Payment Information
                _buildMenuItem(
                  iconData: Icons.payment_outlined, // Fallback icon since no SVG provided
                  title: l10n.paymentInfo,
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 16),

                // 6. Addresses (Expandable to show Default and Add Option)
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.location_on_outlined,
                      size: 24,
                      color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                    ),
                    title: Text(
                      l10n.addresses,
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                      ),
                    ),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 40, right: 16),
                        title: Text(
                          'Park Way 145',
                          style: TextStyle(
                            fontFamily: 'SF Compact',
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                          ),
                        ),
                        subtitle: Text(l10n.defaultAddress, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                        trailing: const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 40, right: 16),
                        leading: const Icon(Icons.add, color: AppColors.primary),
                        title: Text(
                          l10n.addAddress,
                          style: const TextStyle(
                            fontFamily: 'SF Compact',
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.underConstruction)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 7. Logout Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      l10n.logout,
                      style: const TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthCubit>().logOut();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    String? iconPath,
    IconData? iconData,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(isDark ? Colors.white : const Color(0xFF1E1E1E), BlendMode.srcIn),
              )
            else if (iconData != null)
              Icon(
                iconData,
                size: 24,
                color: isDark ? Colors.white : const Color(0xFF1E1E1E),
              ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
