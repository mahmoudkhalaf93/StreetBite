import '../../domain/entities/meal.dart';

class MealModel extends Meal {
  const MealModel({
    required super.idMeal,
    required super.strMeal,
    super.strMealAlternate,
    super.strCategory,
    super.strArea,
    super.strCountry,
    super.strInstructions,
    super.strMealThumb,
    super.strTags,
    super.strYoutube,
    super.ingredients = const [],
    super.measures = const [],
    super.strSource,
    super.strImageSource,
    super.dateModified,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final List<String> extractedIngredients = [];
    final List<String> extractedMeasures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        extractedIngredients.add(ingredient.toString().trim());
      }
      if (measure != null && measure.toString().trim().isNotEmpty) {
        extractedMeasures.add(measure.toString().trim());
      } else {
        if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
          extractedMeasures.add('');
        }
      }
    }

    return MealModel(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealAlternate: json['strMealAlternate'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strCountry: json['strCountry'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      strTags: json['strTags'],
      strYoutube: json['strYoutube'],
      ingredients: extractedIngredients,
      measures: extractedMeasures,
      strSource: json['strSource'],
      strImageSource: json['strImageSource'],
      dateModified: json['dateModified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idMeal'] = idMeal;
    data['strMeal'] = strMeal;
    data['strMealAlternate'] = strMealAlternate;
    data['strCategory'] = strCategory;
    data['strArea'] = strArea;
    data['strCountry'] = strCountry;
    data['strInstructions'] = strInstructions;
    data['strMealThumb'] = strMealThumb;
    data['strTags'] = strTags;
    data['strYoutube'] = strYoutube;
    data['strSource'] = strSource;
    data['strImageSource'] = strImageSource;
    data['dateModified'] = dateModified;

    for (int i = 0; i < ingredients.length; i++) {
      data['strIngredient${i + 1}'] = ingredients[i];
    }
    for (int i = 0; i < measures.length; i++) {
      data['strMeasure${i + 1}'] = measures[i];
    }

    return data;
  }
}
