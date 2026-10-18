import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../home/home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Browse Screen')),
    const Center(child: Text('Orders Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
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
          backgroundColor: Colors.white,
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
            if (isSelected)
              SvgPicture.asset(
                'assets/icons/home_indicator.svg',
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              )
            else
              const SizedBox(height: 4), // Placeholder for the indicator height
            const SizedBox(height: 4),
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              height: 24,
            ),
          ],
        ),
      ),
      label: label,
    );
  }
}
