import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> searchMealsByName(String query);
  Future<List<MealModel>> searchMealsByFirstLetter(String letter);
  Future<MealModel> getMealDetails(String id);
  Future<MealModel> getRandomMeal();
  Future<List<CategoryModel>> getCategories();
  Future<List<MealModel>> filterByCategory(String category);
  Future<List<MealModel>> filterByArea(String area);
  Future<List<MealModel>> filterByIngredient(String ingredient);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  MealRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MealModel>> searchMealsByName(String query) async {
    try {
      final response = await dio.get('${baseUrl}search.php', queryParameters: {'s': query});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        final List meals = data['meals'];
        return meals.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch meals');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealModel>> searchMealsByFirstLetter(String letter) async {
    try {
      final response = await dio.get('${baseUrl}search.php', queryParameters: {'f': letter});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        final List meals = data['meals'];
        return meals.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch meals by letter');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MealModel> getMealDetails(String id) async {
    try {
      final response = await dio.get('${baseUrl}lookup.php', queryParameters: {'i': id});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null || (data['meals'] as List).isEmpty) {
          throw ServerException(message: 'Meal not found');
        }
        return MealModel.fromJson(data['meals'][0]);
      } else {
        throw ServerException(message: 'Failed to fetch meal details');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MealModel> getRandomMeal() async {
    try {
      final response = await dio.get('${baseUrl}random.php');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null || (data['meals'] as List).isEmpty) {
          throw ServerException(message: 'Random meal not found');
        }
        return MealModel.fromJson(data['meals'][0]);
      } else {
        throw ServerException(message: 'Failed to fetch random meal');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('${baseUrl}categories.php');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['categories'] == null) return [];
        final List categories = data['categories'];
        return categories.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch categories');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealModel>> filterByCategory(String category) async {
    try {
      final response = await dio.get('${baseUrl}filter.php', queryParameters: {'c': category});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        final List meals = data['meals'];
        return meals.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to filter by category');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealModel>> filterByArea(String area) async {
    try {
      final response = await dio.get('${baseUrl}filter.php', queryParameters: {'a': area});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        final List meals = data['meals'];
        return meals.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to filter by area');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealModel>> filterByIngredient(String ingredient) async {
    try {
      final response = await dio.get('${baseUrl}filter.php', queryParameters: {'i': ingredient});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) return [];
        final List meals = data['meals'];
        return meals.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to filter by ingredient');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
