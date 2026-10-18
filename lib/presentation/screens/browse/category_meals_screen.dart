import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/meal.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/cart/cart_cubit.dart';
import '../../blocs/meal/meal_cubit.dart';
import '../meal/meal_details_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String categoryName;
  final String apiQuery;
  final bool isAreaFilter;
  final String? iconPath;

  const CategoryMealsScreen({
    super.key,
    required this.categoryName,
    required this.apiQuery,
    this.isAreaFilter = false,
    this.iconPath,
  });

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isAreaFilter) {
        context.read<MealCubit>().filterByArea(widget.apiQuery);
      } else {
        context.read<MealCubit>().filterByCategory(widget.apiQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.iconPath != null) ...[
              SvgPicture.asset(
                widget.iconPath!,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              widget.categoryName,
              style: const TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: BlocBuilder<MealCubit, MealState>(
        builder: (context, state) {
          if (state is MealLoading || state is MealInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is MealError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () {
                      if (widget.isAreaFilter) {
                        context.read<MealCubit>().filterByArea(widget.apiQuery);
                      } else {
                        context.read<MealCubit>().filterByCategory(widget.apiQuery);
                      }
                    },
                    child: Text(l10n.retry, style: const TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          } else if (state is MealLoaded) {
            final meals = state.meals;
            if (meals.isEmpty) {
              return const Center(child: Text("No meals found in this category."));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.60,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return _buildGridMealCard(context, meals[index], l10n, isDark);
              },
            );
          }
          return const SizedBox();
        },
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
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.categoryName,
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
