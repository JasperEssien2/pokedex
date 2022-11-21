import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:pokedex/data/models/pokemon_type.dart';

import 'pokemon_v2_pokemonstat.dart';

class PokemonV2Pokemon extends Equatable {
  final int? id;
  final String? name;
  final List<PokemonV2PokemonStat>? stats;
  final List<PokemonV2PokemonType>? types;
  final String? spriteSvg;
  final num? height;
  final num? weight;

  const PokemonV2Pokemon({
    this.id,
    this.name,
    this.stats,
    this.spriteSvg,
    this.types,
    this.height,
    this.weight,
  });

  factory PokemonV2Pokemon.fromMap(Map<String, dynamic> data) {
    return PokemonV2Pokemon(
      id: data['id'] as int?,
      name: data['name'] as String?,
      stats: (data['pokemon_v2_pokemonstats'] as List<dynamic>?)
          ?.map((e) => PokemonV2PokemonStat.fromMap(e as Map<String, dynamic>))
          .toList(),
      types: (data['pokemon_v2_pokemontypes'] as List<dynamic>?)
          ?.map((e) => PokemonV2PokemonType.fromJson(e as Map<String, dynamic>))
          .toList(),
      spriteSvg: _parseSpriteImage(data),
      height: data['height'] as int?,
      weight: data['weight'] as int?,
    );
  }

  factory PokemonV2Pokemon.fromMapRestAPI(Map<String, dynamic> data) {
    return PokemonV2Pokemon(
      id: data['id'] as int?,
      name: data['name'] as String?,
      stats: (data['stats'] as List<dynamic>?)
          ?.map((e) =>
              PokemonV2PokemonStat.fromMapRestAPI(e as Map<String, dynamic>))
          .toList(),
      types: (data['types'] as List<dynamic>?)
          ?.map((e) => PokemonV2PokemonType.fromJsonRestfulAPI(
              e as Map<String, dynamic>))
          .toList(),
      spriteSvg: data['sprites']['other']['dream_world']['front_default'],
      height: data['height'] as int?,
      weight: data['weight'] as int?,
    );
  }

  static _parseSpriteImage(Map<String, dynamic> data) {
    final spriteString =
        ((data['pokemon_v2_pokemonsprites'] as List).first as Map)['sprites'];

    final sprites = jsonDecode(spriteString);

    return sprites["other"]["dream_world"]["front_default"];
  }

  PokemonV2Pokemon copyWith({
    int? id,
    String? name,
    List<PokemonV2PokemonStat>? pokemonV2Pokemonstats,
    String? pokemonV2Pokemonsprites,
    final List<PokemonV2PokemonType>? types,
    num? height,
    num? weight,
  }) {
    return PokemonV2Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      types: types,
      stats: pokemonV2Pokemonstats ?? stats,
      spriteSvg: pokemonV2Pokemonsprites ?? spriteSvg,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      stats,
      spriteSvg,
      types,
      height,
      weight,
    ];
  }
}
