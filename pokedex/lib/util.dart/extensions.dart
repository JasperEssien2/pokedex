import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokedex/data/models/pokemon_v2_pokemon.dart';
import 'package:pokedex/data/models/pokemon_v2_pokemonstat.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
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

  Color get fromHex {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension HexColor on Color {
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension PokemonEntityExt on PokemonEntity {
  String get imageTag => "image-$id-$isFavourited";
}

extension PokemonModelExt on PokemonV2Pokemon {
  num get bmi => (weight! / math.pow(height!, 2)).round();

  num get avgPower => (stats!
              .reduce((value, element) => PokemonV2PokemonStat(
                  baseStat: value.baseStat! + element.baseStat!))
              .baseStat! /
          6)
      .round();
}

extension BuildContextExt on BuildContext {
  T dataController<T extends BaseListDataController<PokemonEntity>>() {
    return DataControllerProvider.of<T>(this);
  }

  FavoritePokenDataController get favouritePokemonController =>
      dataController<FavoritePokenDataController>();

  PokemonDataController get pokemonController =>
      dataController<PokemonDataController>();
}
