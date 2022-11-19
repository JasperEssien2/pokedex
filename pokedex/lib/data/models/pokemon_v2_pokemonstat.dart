import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'pokemon_v2_stat.dart';

class PokemonV2Pokemonstat extends Equatable {
  final int? baseStat;
  final PokemonV2Stat? pokemonV2Stat;

  const PokemonV2Pokemonstat({this.baseStat, this.pokemonV2Stat});

  factory PokemonV2Pokemonstat.fromMap(Map<String, dynamic> data) {
    return PokemonV2Pokemonstat(
      baseStat: data['base_stat'] as int?,
      pokemonV2Stat: data['pokemon_v2_stat'] == null
          ? null
          : PokemonV2Stat.fromMap(
              data['pokemon_v2_stat'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'base_stat': baseStat,
        'pokemon_v2_stat': pokemonV2Stat?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PokemonV2Pokemonstat].
  factory PokemonV2Pokemonstat.fromJson(String data) {
    return PokemonV2Pokemonstat.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PokemonV2Pokemonstat] to a JSON string.
  String toJson() => json.encode(toMap());

  PokemonV2Pokemonstat copyWith({
    int? baseStat,
    PokemonV2Stat? pokemonV2Stat,
  }) {
    return PokemonV2Pokemonstat(
      baseStat: baseStat ?? this.baseStat,
      pokemonV2Stat: pokemonV2Stat ?? this.pokemonV2Stat,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [baseStat, pokemonV2Stat];
}
