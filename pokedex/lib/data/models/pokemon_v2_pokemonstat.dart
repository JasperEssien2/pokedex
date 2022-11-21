import 'package:equatable/equatable.dart';

import 'pokemon_v2_stat.dart';

class PokemonV2PokemonStat extends Equatable {
  final num? baseStat;
  final PokemonV2Stat? pokemonV2Stat;

  const PokemonV2PokemonStat({this.baseStat, this.pokemonV2Stat});

  factory PokemonV2PokemonStat.fromMap(Map<String, dynamic> data) {
    return PokemonV2PokemonStat(
      baseStat: data['base_stat'] as int?,
      pokemonV2Stat: data['pokemon_v2_stat'] == null
          ? null
          : PokemonV2Stat.fromMap(
              data['pokemon_v2_stat'] as Map<String, dynamic>),
    );
  }

  factory PokemonV2PokemonStat.fromMapRestAPI(Map<String, dynamic> data) {
    return PokemonV2PokemonStat(
      baseStat: data['base_stat'] as int?,
      pokemonV2Stat: data['stat'] == null
          ? null
          : PokemonV2Stat.fromMap(data['stat'] as Map<String, dynamic>),
    );
  }

  PokemonV2PokemonStat copyWith({
    num? baseStat,
    PokemonV2Stat? pokemonV2Stat,
  }) {
    return PokemonV2PokemonStat(
      baseStat: baseStat ?? this.baseStat,
      pokemonV2Stat: pokemonV2Stat ?? this.pokemonV2Stat,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [baseStat, pokemonV2Stat];
}
