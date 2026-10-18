import 'package:equatable/equatable.dart';

class Area extends Equatable {
  final String strArea;

  const Area({required this.strArea});

  @override
  List<Object?> get props => [strArea];
}
