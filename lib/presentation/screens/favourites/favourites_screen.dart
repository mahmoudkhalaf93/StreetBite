import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/meal_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/cart/cart_cubit.dart';
import '../../widgets/favourite_button.dart';
import '../meal/meal_details_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favourites ❤️',
          style: TextStyle(fontFamily: 'SF Pro', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text("Please sign in to view your favourites."))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('favourites')
                  .orderBy('addedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border_rounded,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favourite meals saved yet',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap the ❤️ heart icon on any meal to save it here!',
                          style: TextStyle(
                            fontFamily: 'SF Compact',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final meals = docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return MealModel.fromJson(data);
                }).toList();

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
                    final meal = meals[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailsScreen(meal: meal),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
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
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: meal.strMealThumb != null
                                          ? CachedNetworkImage(
                                              imageUrl: meal.strMealThumb!,
                                              fit: BoxFit.cover,
                                              memCacheWidth: 400,
                                            )
                                          : Container(
                                              color: Colors.grey.shade300,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: FavouriteButton(
                                      meal: meal,
                                      size: 20,
                                    ),
                                  ),
                                ],
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
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1E1E1E),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    meal.strCategory ?? 'Food',
                                    style: const TextStyle(
                                      fontFamily: 'SF Compact',
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        context.read<CartCubit>().addToCart(
                                          meal,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              l10n.addedToCart(meal.strMeal),
                                            ),
                                            backgroundColor: AppColors.primary,
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        l10n.addToCart,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
