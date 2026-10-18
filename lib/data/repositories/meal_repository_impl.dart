import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/meal.dart';
import '../../domain/entities/area.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_local_data_source.dart';
import '../datasources/meal_remote_data_source.dart';

/// Pattern: Factory Pattern
/// Why: Decouples the repository from directly depending on concrete data sources and dynamically provides either local or remote data.
class MealDataSourceFactory {
  final MealRemoteDataSource remoteDataSource;
  final MealLocalDataSource localDataSource;

  MealDataSourceFactory({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  MealLocalDataSource getLocal() => localDataSource;
  MealRemoteDataSource getRemote() => remoteDataSource;
}

class MealRepositoryImpl implements MealRepository {
  final MealDataSourceFactory dataSourceFactory;

  MealRepositoryImpl({
    required MealRemoteDataSource remoteDataSource,
    required MealLocalDataSource localDataSource,
  }) : dataSourceFactory = MealDataSourceFactory(
         remoteDataSource: remoteDataSource,
         localDataSource: localDataSource,
       );

  @override
  Future<Either<Failure, List<Meal>>> searchMealsByFirstLetter(
    String letter,
  ) async {
    // 1. Home Screen Default Feed: Try returning home cached meals first
    try {
      final localMeals = await dataSourceFactory
          .getLocal()
          .getLastCachedMeals();
      if (localMeals.isNotEmpty) {
        // Refresh home cache asynchronously in background
        dataSourceFactory
            .getRemote()
            .searchMealsByFirstLetter(letter)
            .then((remoteMeals) {
              if (remoteMeals.isNotEmpty) {
                dataSourceFactory.getLocal().cacheMeals(remoteMeals);
              }
            })
            .catchError((_) {});

        return Right(localMeals);
      }
    } catch (_) {
      // Fallback if no home cache exists
    }

    try {
      final remoteMeals = await dataSourceFactory
          .getRemote()
          .searchMealsByFirstLetter(letter);
      await dataSourceFactory.getLocal().cacheMeals(remoteMeals);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> searchMealsByName(String query) async {
    final cacheKey = 'SEARCH_$query';

    try {
      final localMeals = await dataSourceFactory.getLocal().getCachedMealsByKey(
        cacheKey,
      );
      if (localMeals.isNotEmpty) {
        dataSourceFactory
            .getRemote()
            .searchMealsByName(query)
            .then((remoteMeals) {
              if (remoteMeals.isNotEmpty) {
                dataSourceFactory.getLocal().cacheMealsByKey(
                  cacheKey,
                  remoteMeals,
                );
              }
            })
            .catchError((_) {});

        return Right(localMeals);
      }
    } catch (_) {}

    try {
      final remoteMeals = await dataSourceFactory.getRemote().searchMealsByName(
        query,
      );
      await dataSourceFactory.getLocal().cacheMealsByKey(cacheKey, remoteMeals);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      try {
        final localMeals = await dataSourceFactory
            .getLocal()
            .getCachedMealsByKey(cacheKey);
        return Right(localMeals);
      } on CacheException {
        return Left(ServerFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Meal>> getMealDetails(String id) async {
    try {
      final remoteMeal = await dataSourceFactory.getRemote().getMealDetails(id);
      return Right(remoteMeal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Meal>> getRandomMeal() async {
    try {
      final remoteMeal = await dataSourceFactory.getRemote().getRandomMeal();
      return Right(remoteMeal);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> getRandomSelection() async {
    try {
      final remoteMeals = await dataSourceFactory
          .getRemote()
          .getRandomSelection();
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> getLatestMeals() async {
    try {
      final remoteMeals = await dataSourceFactory.getRemote().getLatestMeals();
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final remoteCategories = await dataSourceFactory
          .getRemote()
          .getCategories();
      return Right(remoteCategories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesList() async {
    try {
      final remoteCategories = await dataSourceFactory
          .getRemote()
          .getCategoriesList();
      return Right(remoteCategories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Area>>> getAreasList() async {
    try {
      final remoteAreas = await dataSourceFactory.getRemote().getAreasList();
      return Right(remoteAreas);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Ingredient>>> getIngredientsList() async {
    try {
      final remoteIngredients = await dataSourceFactory
          .getRemote()
          .getIngredientsList();
      return Right(remoteIngredients);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> filterByCategory(String category) async {
    final cacheKey = 'CAT_$category';

    try {
      final localMeals = await dataSourceFactory.getLocal().getCachedMealsByKey(
        cacheKey,
      );
      if (localMeals.isNotEmpty) {
        dataSourceFactory
            .getRemote()
            .filterByCategory(category)
            .then((remoteMeals) {
              if (remoteMeals.isNotEmpty) {
                dataSourceFactory.getLocal().cacheMealsByKey(
                  cacheKey,
                  remoteMeals,
                );
              }
            })
            .catchError((_) {});

        return Right(localMeals);
      }
    } catch (_) {}

    try {
      final remoteMeals = await dataSourceFactory.getRemote().filterByCategory(
        category,
      );
      await dataSourceFactory.getLocal().cacheMealsByKey(cacheKey, remoteMeals);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> filterByArea(String area) async {
    final cacheKey = 'AREA_$area';

    try {
      final localMeals = await dataSourceFactory.getLocal().getCachedMealsByKey(
        cacheKey,
      );
      if (localMeals.isNotEmpty) {
        dataSourceFactory
            .getRemote()
            .filterByArea(area)
            .then((remoteMeals) {
              if (remoteMeals.isNotEmpty) {
                dataSourceFactory.getLocal().cacheMealsByKey(
                  cacheKey,
                  remoteMeals,
                );
              }
            })
            .catchError((_) {});

        return Right(localMeals);
      }
    } catch (_) {}

    try {
      final remoteMeals = await dataSourceFactory.getRemote().filterByArea(
        area,
      );
      await dataSourceFactory.getLocal().cacheMealsByKey(cacheKey, remoteMeals);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> filterByIngredient(
    String ingredient,
  ) async {
    try {
      final remoteMeals = await dataSourceFactory
          .getRemote()
          .filterByIngredient(ingredient);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> filterByMultiIngredient(
    String ingredients,
  ) async {
    try {
      final remoteMeals = await dataSourceFactory
          .getRemote()
          .filterByMultiIngredient(ingredients);
      return Right(remoteMeals);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
