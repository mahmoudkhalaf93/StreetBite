import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/meal.dart';
import '../../core/theme/app_colors.dart';

class FavouriteButton extends StatelessWidget {
  final Meal meal;
  final double size;

  const FavouriteButton({super.key, required this.meal, this.size = 22.0});

  Future<void> _toggleFavourite(BuildContext context, bool isFav) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favourites')
        .doc(meal.idMeal);

    if (isFav) {
      await docRef.delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${meal.strMeal} removed from Favourites'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      await docRef.set({
        'idMeal': meal.idMeal,
        'strMeal': meal.strMeal,
        'strMealThumb': meal.strMealThumb,
        'strCategory': meal.strCategory,
        'strArea': meal.strArea,
        'strInstructions': meal.strInstructions,
        'addedAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${meal.strMeal} saved to Favourites ❤️'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(meal.idMeal)
          .snapshots(),
      builder: (context, snapshot) {
        final isFav = snapshot.hasData && snapshot.data!.exists;

        return IconButton(
          icon: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFav ? Colors.red : Colors.grey,
            size: size,
          ),
          onPressed: () => _toggleFavourite(context, isFav),
        );
      },
    );
  }
}
