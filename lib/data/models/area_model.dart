import '../../domain/entities/area.dart';

class AreaModel extends Area {
  const AreaModel({required super.strArea});

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      strArea: json['strArea'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strArea': strArea,
    };
  }
}
