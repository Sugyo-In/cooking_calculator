import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'direction.dart';
part 'ingredient.dart';
part 'prep.dart';

class Recipe extends Equatable {
  const Recipe({
    this.name = '',
    this.directions = const [],
    this.servings = 1,
    this.description = '',
  });

  final String name;

  final List<Direction> directions;

  final int servings;

  final String description;

  @override
  List<Object?> get props => [
        name,
        directions,
        servings,
        description,
      ];

  Duration get time => directions.fold(
        const Duration(),
        (time, direction) => time + direction.cookingTime,
      );
}

class StoredRecipe extends Recipe {
  const StoredRecipe({
    required this.id,
    super.name,
    super.directions,
    super.servings,
    super.description,
  });

  final int id;

  @override
  List<Object?> get props => super.props..add(id);
}
