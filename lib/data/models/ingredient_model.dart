import '../../domain/entities/ingredient.dart';

class IngredientModel extends Ingredient {
  const IngredientModel({
    required super.idIngredient,
    required super.strIngredient,
    super.strDescription,
    super.strType,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      idIngredient: json['idIngredient'] ?? '',
      strIngredient: json['strIngredient'] ?? '',
      strDescription: json['strDescription'],
      strType: json['strType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idIngredient': idIngredient,
      'strIngredient': strIngredient,
      'strDescription': strDescription,
      'strType': strType,
    };
  }
}
