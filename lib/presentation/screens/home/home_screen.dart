import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/meal.dart';
import '../../blocs/cart/cart_cubit.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../blocs/meal/meal_cubit.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../meal/meal_details_screen.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  String _extractRegionName(String fullAddress) {
    final parts = fullAddress
        .split(RegExp(r'[,،]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (parts.isEmpty) return fullAddress;

    if (parts.length >= 3) {
      return parts[1]; // District/Region name
    } else if (parts.length == 2) {
      return parts[1];
    }

    return parts.first;
  }

  @override
  void initState() {
    super.initState();
    // Using viewportFraction 0.78 for the "Fastest" banner slider as requested
    _pageController = PageController(viewportFraction: 0.78);
    
    // Fetch meals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealCubit>().fetchMeals();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final user = FirebaseAuth.instance.currentUser;
                          final isArabic = Localizations.localeOf(context).languageCode == 'ar';

                          if (user == null) {
                            return Text(
                              l10n.parkWay,
                              style: const TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('addresses')
                                .where('isDefault', isEqualTo: true)
                                .limit(1)
                                .snapshots(),
                            builder: (context, snapshot) {
                              String addressTitle = l10n.parkWay;
                              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                                final rawAddress = isArabic
                                    ? (data['addressAr'] ?? data['addressEn'] ?? l10n.parkWay)
                                    : (data['addressEn'] ?? l10n.parkWay);
                                addressTitle = _extractRegionName(rawAddress);
                              }

                              return Text(
                                addressTitle,
                                style: const TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    // Language Toggle
                    AnimatedClickButton(
                      onPressed: () => context.read<LocaleCubit>().toggleLocale(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Text(
                          Localizations.localeOf(context).languageCode.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Theme Toggle
                    AnimatedClickButton(
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                        child: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          key: ValueKey(isDark ? 'light' : 'dark'),
                          color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Bell_notification.svg',
                        colorFilter: ColorFilter.mode(isDark ? Colors.white : const Color(0xFF1E1E1E), BlendMode.srcIn),
                      ),
                      onPressed: () {},
                    ),
                    // Cart Icon with Badge
                    BlocBuilder<CartCubit, CartState>(
                      builder: (context, cartState) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/cart.svg',
                                colorFilter: ColorFilter.mode(isDark ? Colors.white : const Color(0xFF1E1E1E), BlendMode.srcIn),
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                            ),
                            if (cartState.cartItems.isNotEmpty)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${cartState.cartItems.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
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
                    color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9FAFB),
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
                    _buildCategoryItem(icon: 'acclaimed.svg', label: l10n.acclaimed, isDark: isDark),
                    _buildCategoryItem(icon: 'healthy.svg', label: l10n.healthy, isDark: isDark),
                    _buildCategoryItem(icon: 'pizza.svg', label: l10n.pizza, isDark: isDark),
                    _buildCategoryItem(icon: 'ramen.svg', label: l10n.ramen, isDark: isDark),
                    _buildCategoryItem(icon: 'burger.svg', label: l10n.burger, isDark: isDark),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Content based on MealCubit State (Hot Offers, Fastest, Recommended)
              BlocBuilder<MealCubit, MealState>(
                builder: (context, state) {
                  if (state is MealLoading || state is MealInitial) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  } else if (state is MealError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(state.message, style: const TextStyle(color: AppColors.error)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              onPressed: () => context.read<MealCubit>().fetchMeals(),
                              child: Text(l10n.retry, style: const TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (state is MealLoaded) {
                    final meals = state.meals;
                    if (meals.isEmpty) {
                      return const Center(child: Text("No meals found."));
                    }

                    // For presentation, slice the list into different categories
                    final hotOffersMeals = meals.take(5).toList();
                    final fastestMeals = meals.skip(5).take(5).toList();
                    final recommendedMeals = meals; // Use all for grid

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 4. Hot Offers Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.hotOffers,
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 210,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: hotOffersMeals.length,
                            itemBuilder: (context, index) {
                              return _buildHotOfferCard(context, hotOffersMeals[index], l10n, isDark);
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 5. Fastest Section (PageView Banner)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            l10n.fastest,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 240,
                          child: PageView.builder(
                            controller: _pageController,
                            padEnds: false, // Start aligning from the left edge
                            itemCount: fastestMeals.isNotEmpty ? fastestMeals.length : meals.length,
                            itemBuilder: (context, index) {
                              return _buildFastestCard(
                                context, 
                                fastestMeals.isNotEmpty ? fastestMeals[index] : meals[index], 
                                l10n, 
                                isDark
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 6. Recommended Section (Two-column GridView)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.recommended,
                                style: TextStyle(
                                  fontFamily: 'SF Pro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.60, // Adjusted to fit image, text, and button
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: recommendedMeals.length,
                          itemBuilder: (context, index) {
                            return _buildGridMealCard(context, recommendedMeals[index], l10n, isDark);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({required String icon, required String label, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE8F8F0),
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
            style: TextStyle(
              fontFamily: 'SF Compact',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotOfferCard(BuildContext context, Meal meal, AppLocalizations l10n, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailsScreen(meal: meal))),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: meal.strMealThumb != null
                  ? CachedNetworkImage(
                      imageUrl: meal.strMealThumb!,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 110,
                        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 110,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.fastfood, color: Colors.grey),
                      ),
                    )
                  : Container(height: 110, color: Colors.grey.shade300, child: const Icon(Icons.fastfood, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.strMeal,
                    style: TextStyle(fontFamily: 'SF Pro', fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E1E1E)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text('20% OFF', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFastestCard(BuildContext context, Meal meal, AppLocalizations l10n, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailsScreen(meal: meal))),
      child: Container(
        margin: const EdgeInsets.only(right: 16.0), // Margin gives the gap between PageView items
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: meal.strMealThumb != null
                  ? CachedNetworkImage(
                      imageUrl: meal.strMealThumb!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 160,
                        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 160,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.fastfood, size: 48, color: Colors.grey),
                      ),
                    )
                  : Container(height: 160, color: Colors.grey.shade300, child: const Icon(Icons.fastfood, size: 48, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            Text(
              meal.strMeal,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E1E1E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '4.8', // Mocked rating
                  style: TextStyle(
                    fontFamily: 'SF Compact',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset('assets/icons/Star.svg', width: 14, height: 14),
                const SizedBox(width: 4),
                const Text(
                  '(120)', // Mocked review count
                  style: TextStyle(fontFamily: 'SF Compact', fontSize: 14, color: Color(0xFF9CA3AF)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                ),
                Text(
                  '2.4 ${l10n.km}', // Formatted nice distance
                  style: const TextStyle(fontFamily: 'SF Compact', fontSize: 14, color: Color(0xFF9CA3AF)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                ),
                Text(
                  '20-25 ${l10n.min}', // Formatted nice time
                  style: const TextStyle(fontFamily: 'SF Compact', fontSize: 14, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridMealCard(BuildContext context, Meal meal, AppLocalizations l10n, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailsScreen(meal: meal))),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: meal.strMealThumb != null
                    ? CachedNetworkImage(
                        imageUrl: meal.strMealThumb!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                          child: const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      )
                    : Container(color: Colors.grey.shade300, child: const Icon(Icons.fastfood, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.strMeal,
                    style: TextStyle(fontFamily: 'SF Pro', fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E1E1E)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.strCategory ?? 'Food',
                    style: const TextStyle(fontFamily: 'SF Compact', fontSize: 12, color: Color(0xFF9CA3AF)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E1E1E))),
                      const Spacer(),
                      Text('20 ${l10n.min}', style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        context.read<CartCubit>().addToCart(meal);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.addedToCart(meal.strMeal)),
                            backgroundColor: AppColors.primary,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(l10n.addToCart, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedClickButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const AnimatedClickButton({super.key, required this.child, required this.onPressed});

  @override
  State<AnimatedClickButton> createState() => _AnimatedClickButtonState();
}

class _AnimatedClickButtonState extends State<AnimatedClickButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
