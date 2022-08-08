import 'package:freezed_annotation/freezed_annotation.dart';

import 'amount/amount.dart';
import 'direction.dart';
import 'ingredient.dart';

part 'recipe.freezed.dart';

@freezed
class Recipe<T extends Amount> with _$Recipe<T> {
  const Recipe._();

  const factory Recipe({
    required String name,
    required List<Direction<T>> directions,
    @Default(1) int servings,
    @Default('') String description,
  }) = _Recipe;

  Map<Ingredient, Amount> get amountByIngredient {
    final merged = <Ingredient, Amount>{};

    for (final direction in directions) {
      direction.amountByIngredient.forEach((ingredient, amount) {
        merged.update(
          ingredient,
          (value) => value + amount,
          ifAbsent: () => amount,
        );
      });
    }

    return merged;
  }

  Duration get time => directions.fold(
        const Duration(),
        (time, direction) => time + direction.time,
      );

  Map<Ingredient, Amount> getAmountByIngredientServingsFor(int servings) {
    final calculated = <Ingredient, Amount>{};

    amountByIngredient.forEach((ingredient, amount) {
      calculated.update(
        ingredient,
        (value) => value + (amount / servings),
        ifAbsent: () => amount / servings,
      );
    });

    return calculated;
  }
}
