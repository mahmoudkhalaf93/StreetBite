import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location_in_bar.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.parkWay,
                        style: const TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/Bell_notification.svg'),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/cart.svg'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      SvgPicture.asset(
                        'assets/icons/search_in_textfield.svg',
                        colorFilter: const ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: l10n.searchHint,
                            hintStyle: const TextStyle(
                              fontFamily: 'SF Compact',
                              color: Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Categories (Horizontal Scroll)
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildCategoryItem(icon: 'acclaimed.svg', label: l10n.acclaimed),
                    _buildCategoryItem(icon: 'healthy.svg', label: l10n.healthy),
                    _buildCategoryItem(icon: 'pizza.svg', label: l10n.pizza),
                    _buildCategoryItem(icon: 'ramen.svg', label: l10n.ramen),
                    _buildCategoryItem(icon: 'burger.svg', label: l10n.burger),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Fastest Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  l10n.fastest,
                  style: const TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 240,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildFastestCard(
                      imagePath: 'unknown',
                      name: 'Morning Delights Café',
                      rating: '4.9',
                      reviewsCount: '103',
                      distance: '2.3',
                      time: '25',
                      l10n: l10n,
                    ),
                    _buildFastestCard(
                      imagePath: 'unknown',
                      name: 'Sunrise Eats',
                      rating: '4.8',
                      reviewsCount: '561',
                      distance: '2.3', // Unknown from crop, estimating
                      time: 'unknown',
                      l10n: l10n,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Recommended Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  l10n.recommended,
                  style: const TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildRecommendedCard(
                    imagePath: 'unknown',
                    name: 'Sabor Mexicano Grill',
                    rating: '4.7',
                    reviewsCount: '59',
                    distance: '1.5',
                    time: '20',
                    deliveryFeeText: l10n.deliveryFeeText('0', '30'),
                    l10n: l10n,
                  ),
                  _buildRecommendedCard(
                    imagePath: 'unknown',
                    name: 'Burger Haven',
                    rating: '4.9',
                    reviewsCount: '1940',
                    distance: '4',
                    time: '35',
                    deliveryFeeText: 'unknown', // not visible in crop
                    l10n: l10n,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({required String icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F0), // Light green
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/$icon',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'SF Compact',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFastestCard({
    required String imagePath,
    required String name,
    required String rating,
    required String reviewsCount,
    required String distance,
    required String time,
    required AppLocalizations l10n,
  }) {
    // We use a fixed width taking ~75% of screen
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.grey.shade300, // Placeholder
              child: const Icon(Icons.image, color: Colors.grey, size: 48), // Placeholder image
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                rating,
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset('assets/icons/Star.svg', width: 14, height: 14),
              const SizedBox(width: 4),
              Text(
                '($reviewsCount)',
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
              ),
              Text(
                '$distance${l10n.km}',
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
              ),
              Text(
                time == 'unknown' ? l10n.unknown : '$time ${l10n.min}',
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard({
    required String imagePath,
    required String name,
    required String rating,
    required String reviewsCount,
    required String distance,
    required String time,
    required String deliveryFeeText,
    required AppLocalizations l10n,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey.shade300, // Placeholder
              child: const Icon(Icons.image, color: Colors.grey, size: 48), // Placeholder image
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                rating,
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(width: 4),
              SvgPicture.asset('assets/icons/Star.svg', width: 14, height: 14),
              const SizedBox(width: 4),
              Text(
                '($reviewsCount)',
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
              ),
              Text(
                '$distance${l10n.km}',
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
              ),
              Text(
                time == 'unknown' ? l10n.unknown : '$time ${l10n.min}',
                style: const TextStyle(
                  fontFamily: 'SF Compact',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          if (deliveryFeeText != 'unknown') ...[
            const SizedBox(height: 4),
            Text(
              deliveryFeeText,
              style: const TextStyle(
                fontFamily: 'SF Compact',
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
