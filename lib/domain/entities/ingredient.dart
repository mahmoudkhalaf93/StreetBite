import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String idIngredient;
  final String strIngredient;
  final String? strDescription;
  final String? strType;

  const Ingredient({
    required this.idIngredient,
    required this.strIngredient,
    this.strDescription,
    this.strType,
  });

  @override
  List<Object?> get props => [
    idIngredient,
    strIngredient,
    strDescription,
    strType,
  ];
}
