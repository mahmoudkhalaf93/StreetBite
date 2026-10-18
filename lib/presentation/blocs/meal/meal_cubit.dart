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
    // Fetch some default meals (e.g. searching 'c' gives a good list like Chicken)
    final result = await repository.searchMealsByFirstLetter('c');
    
    result.fold(
      (failure) => emit(MealError(failure.props.first as String)),
      (meals) => emit(MealLoaded(meals)),
    );
  }
}
