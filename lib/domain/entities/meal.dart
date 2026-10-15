import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String idMeal;
  final String strMeal;
  final String? strMealAlternate;
  final String? strCategory;
  final String? strArea;
  final String? strCountry;
  final String? strInstructions;
  final String? strMealThumb;
  final String? strTags;
  final String? strYoutube;
  final List<String> ingredients;
  final List<String> measures;
  final String? strSource;
  final String? strImageSource;
  final String? dateModified;

  const Meal({
    required this.idMeal,
    required this.strMeal,
    this.strMealAlternate,
    this.strCategory,
    this.strArea,
    this.strCountry,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
    this.strSource,
    this.strImageSource,
    this.dateModified,
  });

  @override
  List<Object?> get props => [
        idMeal,
        strMeal,
        strMealAlternate,
        strCategory,
        strArea,
        strCountry,
        strInstructions,
        strMealThumb,
        strTags,
        strYoutube,
        ingredients,
        measures,
        strSource,
        strImageSource,
        dateModified,
      ];
}
