import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokedex/data/models/pokemon_v2_pokemon.dart';
import 'package:pokedex/data/models/pokemon_v2_pokemonstat.dart';
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

extension StringExt on String {
  String get capitilizeFirst =>
      isEmpty ? this : replaceFirst(this[0], this[0].toUpperCase());
}

extension PokemonEntityExt on PokemonEntity {
  String get imageTag => "image-$id-$isFavourited";
}

extension PokemonModelExt on PokemonV2Pokemon {
  num get bmi => weight! / math.pow(height!, 2);

  num get avgPower =>
      stats!
          .reduce((value, element) => PokemonV2PokemonStat(
              baseStat: value.baseStat! + element.baseStat!))
          .baseStat! /
      6;
}

extension BuildContextExt on BuildContext {
  T dataController<T extends BaseDataController<PokemonList>>() {
    return DataControllerProvider.of<T>(this);
  }

  FavoritePokenDataController get favouritePokemonController =>
      dataController<FavoritePokenDataController>();

  PokemonDataController get pokemonController =>
      dataController<PokemonDataController>();
}
