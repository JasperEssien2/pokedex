import 'package:equatable/equatable.dart';

import 'pokemon_v2_stat.dart';

class PokemonV2Pokemonstat extends Equatable {
  final num? baseStat;
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

  PokemonV2Pokemonstat copyWith({
    num? baseStat,
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
