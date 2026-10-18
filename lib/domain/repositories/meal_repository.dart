import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/category.dart';
import '../entities/meal.dart';
import '../entities/area.dart';
import '../entities/ingredient.dart';

abstract class MealRepository {
  Future<Either<Failure, List<Meal>>> searchMealsByName(String query);
  Future<Either<Failure, List<Meal>>> searchMealsByFirstLetter(String letter);
  Future<Either<Failure, Meal>> getMealDetails(String id);
  Future<Either<Failure, Meal>> getRandomMeal();
  Future<Either<Failure, List<Meal>>> getRandomSelection();
  Future<Either<Failure, List<Meal>>> getLatestMeals();
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Category>>> getCategoriesList();
  Future<Either<Failure, List<Area>>> getAreasList();
  Future<Either<Failure, List<Ingredient>>> getIngredientsList();
  Future<Either<Failure, List<Meal>>> filterByCategory(String category);
  Future<Either<Failure, List<Meal>>> filterByArea(String area);
  Future<Either<Failure, List<Meal>>> filterByIngredient(String ingredient);
  Future<Either<Failure, List<Meal>>> filterByMultiIngredient(
    String ingredients,
  );
}
