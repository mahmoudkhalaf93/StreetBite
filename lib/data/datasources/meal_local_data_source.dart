import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/exceptions.dart';
import '../models/meal_model.dart';

abstract class MealLocalDataSource {
  Future<List<MealModel>> getLastCachedMeals();
  Future<void> cacheMeals(List<MealModel> mealsToCache);
}

class MealLocalDataSourceImpl implements MealLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedMealsKey = 'CACHED_MEALS';

  MealLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheMeals(List<MealModel> mealsToCache) async {
    final List<Map<String, dynamic>> jsonList =
        mealsToCache.map((meal) => meal.toJson()).toList();
    await sharedPreferences.setString(cachedMealsKey, json.encode(jsonList));
  }

  @override
  Future<List<MealModel>> getLastCachedMeals() async {
    final jsonString = sharedPreferences.getString(cachedMealsKey);
    if (jsonString != null) {
      final List decodedList = json.decode(jsonString);
      return decodedList
          .map((jsonMap) => MealModel.fromJson(jsonMap))
          .toList();
    } else {
      throw CacheException(message: 'No cached meals found');
    }
  }
}
