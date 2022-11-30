import 'package:equatable/equatable.dart';

class PokemonV2Type extends Equatable {
  final String? name;

  const PokemonV2Type({this.name});

  factory PokemonV2Type.fromJson(Map<String, dynamic> json) => PokemonV2Type(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  PokemonV2Type copyWith({
    String? name,
  }) {
    return PokemonV2Type(
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name];
}

class PokemonV2PokemonType extends Equatable {
  final PokemonV2Type? pokemonV2Type;

  const PokemonV2PokemonType({this.pokemonV2Type});

  factory PokemonV2PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonV2PokemonType(
      pokemonV2Type: json['pokemon_v2_type'] == null
          ? null
          : PokemonV2Type.fromJson(
              json['pokemon_v2_type'] as Map<String, dynamic>),
    );
  }

  factory PokemonV2PokemonType.fromJsonRestfulAPI(Map<String, dynamic> json) {
    return PokemonV2PokemonType(
      pokemonV2Type: json['type'] == null
          ? null
          : PokemonV2Type.fromJson(json['type'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'pokemon_v2_type': pokemonV2Type?.toJson(),
      };

  PokemonV2PokemonType copyWith({
    PokemonV2Type? pokemonV2Type,
  }) {
    return PokemonV2PokemonType(
      pokemonV2Type: pokemonV2Type ?? this.pokemonV2Type,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [pokemonV2Type];
}
