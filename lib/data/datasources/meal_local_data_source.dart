import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/exceptions.dart';
import '../models/meal_model.dart';

abstract class MealLocalDataSource {
  Future<List<MealModel>> getLastCachedMeals();
  Future<void> cacheMeals(List<MealModel> mealsToCache);
  Future<List<MealModel>> getCachedMealsByKey(String key);
  Future<void> cacheMealsByKey(String key, List<MealModel> mealsToCache);
}

class MealLocalDataSourceImpl implements MealLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String homeCachedMealsKey = 'HOME_CACHED_MEALS';

  MealLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheMeals(List<MealModel> mealsToCache) async {
    await cacheMealsByKey(homeCachedMealsKey, mealsToCache);
  }

  @override
  Future<List<MealModel>> getLastCachedMeals() async {
    return getCachedMealsByKey(homeCachedMealsKey);
  }

  @override
  Future<void> cacheMealsByKey(String key, List<MealModel> mealsToCache) async {
    final List<Map<String, dynamic>> jsonList =
        mealsToCache.map((meal) => meal.toJson()).toList();
    await sharedPreferences.setString(key, json.encode(jsonList));
  }

  @override
  Future<List<MealModel>> getCachedMealsByKey(String key) async {
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      final List decodedList = json.decode(jsonString);
      return decodedList
          .map((jsonMap) => MealModel.fromJson(jsonMap))
          .toList();
    } else {
      throw CacheException(message: 'No cached meals found for key: $key');
    }
  }
}
