import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  const Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  @override
  List<Object?> get props => [
    idCategory,
    strCategory,
    strCategoryThumb,
    strCategoryDescription,
  ];
}
