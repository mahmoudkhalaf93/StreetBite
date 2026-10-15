import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_local_data_source.dart';
import '../datasources/meal_remote_data_source.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;
  final MealLocalDataSource localDataSource;

  MealRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Meal>>> searchMealsByName(String query) async {
    try {
      final remoteMeals = await remoteDataSource.searchMealsByName(query);
      await localDataSource.cacheMeals(remoteMeals);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      try {
        final localMeals = await localDataSource.getLastCachedMeals();
        return Right(localMeals);
      } on CacheException {
        return Left(ServerFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> searchMealsByFirstLetter(String letter) async {
    try {
      final remoteMeals = await remoteDataSource.searchMealsByFirstLetter(letter);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Meal>> getMealDetails(String id) async {
    try {
      final remoteMeal = await remoteDataSource.getMealDetails(id);
      return Right(remoteMeal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Meal>> getRandomMeal() async {
    try {
      final remoteMeal = await remoteDataSource.getRandomMeal();
      return Right(remoteMeal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final remoteCategories = await remoteDataSource.getCategories();
      return Right(remoteCategories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> filterByCategory(String category) async {
    try {
      final remoteMeals = await remoteDataSource.filterByCategory(category);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> filterByArea(String area) async {
    try {
      final remoteMeals = await remoteDataSource.filterByArea(area);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> filterByIngredient(String ingredient) async {
    try {
      final remoteMeals = await remoteDataSource.filterByIngredient(ingredient);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
