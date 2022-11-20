import 'package:equatable/equatable.dart';

import 'pokemon_v2_pokemon.dart';

class PokemonModel extends Equatable {
  final List<PokemonV2Pokemon>? pokemonV2Pokemon;

  const PokemonModel({this.pokemonV2Pokemon});

  factory PokemonModel.fromMap(Map<String, dynamic> data) => PokemonModel(
        pokemonV2Pokemon: (data['pokemon_v2_pokemon'] as List<dynamic>?)
            ?.map((e) => PokemonV2Pokemon.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  PokemonModel copyWith({
    List<PokemonV2Pokemon>? pokemonV2Pokemon,
  }) {
    return PokemonModel(
      pokemonV2Pokemon: pokemonV2Pokemon ?? this.pokemonV2Pokemon,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [pokemonV2Pokemon];
}
