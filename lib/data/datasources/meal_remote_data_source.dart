import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../models/area_model.dart';
import '../models/ingredient_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> searchMealsByName(String query);
  Future<List<MealModel>> searchMealsByFirstLetter(String letter);
  Future<MealModel> getMealDetails(String id);
  Future<MealModel> getRandomMeal();
  Future<List<MealModel>> getRandomSelection(); // Premium API simulation
  Future<List<MealModel>> getLatestMeals(); // Premium API simulation
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>> getCategoriesList(); // list.php?c=list
  Future<List<AreaModel>> getAreasList(); // list.php?a=list
  Future<List<IngredientModel>> getIngredientsList(); // list.php?i=list
  Future<List<MealModel>> filterByCategory(String category);
  Future<List<MealModel>> filterByArea(String area);
  Future<List<MealModel>> filterByIngredient(String ingredient);
  Future<List<MealModel>> filterByMultiIngredient(String ingredients); // Premium API simulation
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';
  static const String premiumBaseUrl = 'https://www.themealdb.com/api/json/v2/1/'; // Using test key '1' for now

  MealRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MealModel>> searchMealsByName(String query) async {
    return _fetchMealList('${baseUrl}search.php', {'s': query});
  }

  @override
  Future<List<MealModel>> searchMealsByFirstLetter(String letter) async {
    return _fetchMealList('${baseUrl}search.php', {'f': letter});
  }

  @override
  Future<MealModel> getMealDetails(String id) async {
    final meals = await _fetchMealList('${baseUrl}lookup.php', {'i': id});
    if (meals.isEmpty) throw ServerException(message: 'Meal not found');
    return meals.first;
  }

  @override
  Future<MealModel> getRandomMeal() async {
    final meals = await _fetchMealList('${baseUrl}random.php', {});
    if (meals.isEmpty) throw ServerException(message: 'Random meal not found');
    return meals.first;
  }

  @override
  Future<List<MealModel>> getRandomSelection() async {
    return _fetchMealList('${premiumBaseUrl}randomselection.php', {});
  }

  @override
  Future<List<MealModel>> getLatestMeals() async {
    return _fetchMealList('${premiumBaseUrl}latest.php', {});
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('${baseUrl}categories.php');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['categories'] == null) return [];
        return (data['categories'] as List).map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch categories');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesList() async {
    try {
      final response = await dio.get('${baseUrl}list.php', queryParameters: {'c': 'list'});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        // list.php?c=list returns only strCategory, we adapt it to CategoryModel
        return (data['meals'] as List).map((json) => CategoryModel(
          idCategory: '', 
          strCategory: json['strCategory'] ?? '', 
          strCategoryThumb: '', 
          strCategoryDescription: ''
        )).toList();
      } else {
        throw ServerException(message: 'Failed to fetch category list');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<AreaModel>> getAreasList() async {
    try {
      final response = await dio.get('${baseUrl}list.php', queryParameters: {'a': 'list'});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        return (data['meals'] as List).map((json) => AreaModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch area list');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<IngredientModel>> getIngredientsList() async {
    try {
      final response = await dio.get('${baseUrl}list.php', queryParameters: {'i': 'list'});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        return (data['meals'] as List).map((json) => IngredientModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch ingredients list');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealModel>> filterByCategory(String category) async {
    return _fetchMealList('${baseUrl}filter.php', {'c': category});
  }

  @override
  Future<List<MealModel>> filterByArea(String area) async {
    return _fetchMealList('${baseUrl}filter.php', {'a': area});
  }

  @override
  Future<List<MealModel>> filterByIngredient(String ingredient) async {
    return _fetchMealList('${baseUrl}filter.php', {'i': ingredient});
  }

  @override
  Future<List<MealModel>> filterByMultiIngredient(String ingredients) async {
    return _fetchMealList('${premiumBaseUrl}filter.php', {'i': ingredients});
  }

  // Helper method to reduce code duplication for fetching meal lists
  Future<List<MealModel>> _fetchMealList(String url, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(url, queryParameters: params);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        return (data['meals'] as List).map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch meals from $url');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
