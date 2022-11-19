import 'package:flutter/material.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/domain/repository_base.dart';
import 'package:pokedex/presentation/data_controller.dart';
import 'package:pokedex/presentation/data_provider.dart';

extension NumExt on num {
  String get pokemonId {
    var strId = toString();

    if (this < 10) {
      strId = strId.padLeft(3, '0');
    } else if (this < 100) {
      strId = strId.padLeft(3, '0');
    }

    return "#$strId";
  }
}

extension PokemonEntityExt on PokemonEntity {
  String get imageTag => "image-$id-$isFavourited";
}

extension BuildContextExt on BuildContext {
  T dataController<T extends BaseDataController<PokemonList>>() {
    return DataControllerProvider.of<T>(this);
  }

  FavoritePokenDataController get favouritePokemonController =>
      dataController<FavoritePokenDataController>();
}
