import 'dart:async';
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
import '../vendor_map/vendor_map_screen.dart';
import '../browse/category_meals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _fastestController;
  late PageController _hotOffersController;
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> _homeCategories = [
    {
      'labelEn': 'Ramen',
      'labelAr': 'رامن',
      'icon': 'assets/icons/ramen.svg',
      'query': 'Seafood',
      'isArea': false,
    },
    {
      'labelEn': 'Pizza',
      'labelAr': 'بيتزا',
      'icon': 'assets/icons/pizza.svg',
      'query': 'Miscellaneous',
      'isArea': false,
    },
    {
      'labelEn': 'Fast Food',
      'labelAr': 'وجبات سريعة',
      'icon': 'assets/icons/fast_food.svg',
      'query': 'Beef',
      'isArea': false,
    },
    {
      'labelEn': 'Healthy',
      'labelAr': 'أكل صحي',
      'icon': 'assets/icons/healthy.svg',
      'query': 'Vegetarian',
      'isArea': false,
    },
    {
      'labelEn': 'Salads',
      'labelAr': 'سلاطات',
      'icon': 'assets/icons/salads.svg',
      'query': 'Side',
      'isArea': false,
    },
    {
      'labelEn': 'Desserts',
      'labelAr': 'حلويات',
      'icon': 'assets/icons/icecream.svg',
      'query': 'Dessert',
      'isArea': false,
    },
    {
      'labelEn': 'Meat',
      'labelAr': 'لحوم',
      'icon': 'assets/icons/meat.svg',
      'query': 'Lamb',
      'isArea': false,
    },
    {
      'labelEn': 'Asian',
      'labelAr': 'آسيوي',
      'icon': 'assets/icons/asian.svg',
      'query': 'Japanese',
      'isArea': true,
    },
    {
      'labelEn': 'Bakery',
      'labelAr': 'مخبوزات',
      'icon': 'assets/icons/bakery.svg',
      'query': 'Breakfast',
      'isArea': false,
    },
    {
      'labelEn': 'Italian',
      'labelAr': 'إيطالي',
      'icon': 'assets/icons/italian.svg',
      'query': 'Italian',
      'isArea': true,
    },
  ];

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
    _fastestController = PageController(viewportFraction: 0.78);
    _hotOffersController = PageController(viewportFraction: 0.92);

    _startAutoBannerScroll();

    // Fetch meals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealCubit>().fetchMeals();
    });
  }

  void _startAutoBannerScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_hotOffersController.hasClients) {
        _currentBannerIndex++;
        if (_currentBannerIndex >= 5) _currentBannerIndex = 0;
        _hotOffersController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _fastestController.dispose();
    _hotOffersController.dispose();
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VendorMapScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/location_in_bar.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Builder(
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
                        ],
                      ),
                    ),
                    const Spacer(),
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
                          onSubmitted: (query) {
                            if (query.trim().isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryMealsScreen(
                                    categoryName: 'Search: ${query.trim()}',
                                    apiQuery: query.trim(),
                                    isSearchMode: true,
                                  ),
                                ),
                              );
                            }
                          },
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

              // 3. Categories (Horizontal Scroll matching Browse categories)
              SizedBox(
                height: 95,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _homeCategories.length,
                  itemBuilder: (context, index) {
                    final cat = _homeCategories[index];
                    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
                    final label = isArabic ? cat['labelAr'] : cat['labelEn'];

                    return _buildCategoryItem(
                      icon: cat['icon'],
                      label: label,
                      isDark: isDark,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryMealsScreen(
                              categoryName: label,
                              apiQuery: cat['query'],
                              isAreaFilter: cat['isArea'],
                              iconPath: cat['icon'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Content based on MealCubit State
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

                    final hotOffersMeals = meals.take(5).toList();
                    final fastestMeals = meals.skip(5).take(5).toList();
                    final recommendedMeals = meals;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 4. Hot Offers Section (Auto-Sliding Banners)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            l10n.hotOffers,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 150,
                          child: PageView.builder(
                            controller: _hotOffersController,
                            onPageChanged: (index) {
                              setState(() => _currentBannerIndex = index);
                            },
                            itemCount: hotOffersMeals.length,
                            itemBuilder: (context, index) {
                              return _buildHotOfferBannerCard(
                                context,
                                hotOffersMeals[index],
                                l10n,
                                isDark,
                                index,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Page Indicator Dots for Banners
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            hotOffersMeals.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentBannerIndex == index ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentBannerIndex == index
                                    ? AppColors.primary
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
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
                            controller: _fastestController,
                            padEnds: false,
                            itemCount: fastestMeals.isNotEmpty ? fastestMeals.length : meals.length,
                            itemBuilder: (context, index) {
                              return _buildFastestCard(
                                context,
                                fastestMeals.isNotEmpty ? fastestMeals[index] : meals[index],
                                l10n,
                                isDark,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 6. Recommended Section (Two-column GridView)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            l10n.recommended,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.60,
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

  Widget _buildCategoryItem({
    required String icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE8F8F0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon.startsWith('assets/') ? icon : 'assets/icons/$icon',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: 6),
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
      ),
    );
  }

  // Rectangular Auto-Sliding Banner for Hot Offers
  Widget _buildHotOfferBannerCard(
      BuildContext context, Meal meal, AppLocalizations l10n, bool isDark, int index) {
    final discounts = ['20% OFF', '30% OFF', 'SPECIAL DEAL', 'BUY 1 GET 1', '25% OFF'];
    final discountText = discounts[index % discounts.length];

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailsScreen(meal: meal))),
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                : [AppColors.primary, const Color(0xFF009B5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Text & Info Column
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            discountText,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.strMeal,
                          style: const TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Text(
                              'Order Now',
                              style: TextStyle(
                                fontFamily: 'SF Compact',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white70),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Image Container
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: meal.strMealThumb != null
                          ? CachedNetworkImage(
                              imageUrl: meal.strMealThumb!,
                              height: 110,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.black12,
                                child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.black12,
                                child: const Icon(Icons.fastfood, color: Colors.white),
                              ),
                            )
                          : Container(color: Colors.black12, child: const Icon(Icons.fastfood, color: Colors.white)),
                    ),
                  ),
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
        margin: const EdgeInsets.only(right: 16.0),
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
                  '4.8',
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
                  '(120)',
                  style: TextStyle(fontFamily: 'SF Compact', fontSize: 14, color: Color(0xFF9CA3AF)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                ),
                Text(
                  '2.4 ${l10n.km}',
                  style: const TextStyle(fontFamily: 'SF Compact', fontSize: 14, color: Color(0xFF9CA3AF)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                ),
                Text(
                  '20-25 ${l10n.min}',
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
