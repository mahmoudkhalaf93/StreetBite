import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/meal.dart';
import '../../../domain/repositories/meal_repository.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object> get props => [];
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealLoaded extends MealState {
  final List<Meal> meals;
  const MealLoaded(this.meals);

  @override
  List<Object> get props => [meals];
}

class MealError extends MealState {
  final String message;
  const MealError(this.message);

  @override
  List<Object> get props => [message];
}

class MealCubit extends Cubit<MealState> {
  final MealRepository repository;

  MealCubit({required this.repository}) : super(MealInitial());

  Future<void> fetchMeals() async {
    emit(MealLoading());
    final result = await repository.searchMealsByFirstLetter('c');
    result.fold(
      (failure) => emit(MealError(failure.props.first as String)),
      (meals) => emit(MealLoaded(meals)),
    );
  }

  Future<void> filterByCategory(String category) async {
    emit(MealLoading());
    final result = await repository.filterByCategory(category);
    result.fold(
      (failure) => emit(MealError(failure.props.first as String)),
      (meals) => emit(MealLoaded(meals)),
    );
  }

  Future<void> filterByArea(String area) async {
    emit(MealLoading());
    final result = await repository.filterByArea(area);
    result.fold(
      (failure) => emit(MealError(failure.props.first as String)),
      (meals) => emit(MealLoaded(meals)),
    );
  }

  Future<void> searchMeals(String query) async {
    emit(MealLoading());
    final result = await repository.searchMealsByName(query);
    result.fold(
      (failure) => emit(MealError(failure.props.first as String)),
      (meals) => emit(MealLoaded(meals)),
    );
  }
}
