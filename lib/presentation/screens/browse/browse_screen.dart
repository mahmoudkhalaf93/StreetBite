import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'category_meals_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Title
              Text(
                'Search',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Search Field
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(24),
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
                        controller: _searchController,
                        onSubmitted: (query) {
                          if (query.trim().isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryMealsScreen(
                                  categoryName: query,
                                  apiQuery: query,
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
              const SizedBox(height: 28),

              // 3. Categories Header
              Text(
                'Categories',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Grid of Category Cards (Exact match to design image)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final label = isArabic ? cat['labelAr'] : cat['labelEn'];

                  return GestureDetector(
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
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE8F8F0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            cat['icon'],
                            width: 28,
                            height: 28,
                            colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                          ),
                          Text(
                            label,
                            style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
