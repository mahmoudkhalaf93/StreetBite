import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Screens are dynamically generated here so they can access context for l10n
    final List<Widget> screens = [
      const HomeScreen(),
      Center(child: Text(l10n.navBrowse)),
      Center(child: Text(l10n.navOrders)),
      const ProfileScreen(),
    ];

    return Scaffold(
      // Using IndexedStack to preserve state of all screens (e.g. scroll position in Home)
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, 
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: const Color(0xFF9CA3AF),
            selectedLabelStyle: const TextStyle(
              fontFamily: 'SF Compact Display',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'SF Compact Display',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            items: [
              _buildNavItem('assets/icons/home.svg', l10n.navHome, 0),
              _buildNavItem('assets/icons/browse.svg', l10n.navBrowse, 1),
              _buildNavItem('assets/icons/orders.svg', l10n.navOrders, 2),
              _buildNavItem('assets/icons/profile.svg', l10n.navProfile, 3),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label, int index) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primary : const Color(0xFF9CA3AF);

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The animated indicator dot instead of the broken SVG
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: isSelected ? 5.0 : 0.0,
              height: isSelected ? 5.0 : 0.0,
              margin: const EdgeInsets.only(bottom: 4.0),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
      label: label,
    );
  }
}

