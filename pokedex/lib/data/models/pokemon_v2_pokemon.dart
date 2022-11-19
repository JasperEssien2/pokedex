import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'pokemon_v2_pokemonstat.dart';

class PokemonV2Pokemon extends Equatable {
  final int? id;
  final String? name;
  final List<PokemonV2Pokemonstat>? pokemonV2Pokemonstats;
  final String? pokemonV2Pokemonsprites;
  final int? height;
  final int? weight;

  const PokemonV2Pokemon({
    this.id,
    this.name,
    this.pokemonV2Pokemonstats,
    this.pokemonV2Pokemonsprites,
    this.height,
    this.weight,
  });

  factory PokemonV2Pokemon.fromMap(Map<String, dynamic> data) {
    return PokemonV2Pokemon(
      id: data['id'] as int?,
      name: data['name'] as String?,
      pokemonV2Pokemonstats: (data['pokemon_v2_pokemonstats'] as List<dynamic>?)
          ?.map((e) => PokemonV2Pokemonstat.fromMap(e as Map<String, dynamic>))
          .toList(),
      pokemonV2Pokemonsprites: _parseSpriteImage(data),
      height: data['height'] as int?,
      weight: data['weight'] as int?,
    );
  }

  static _parseSpriteImage(Map<String, dynamic> data) {
    final spriteString =
        ((data['pokemon_v2_pokemonsprites'] as List).first as Map)['sprites'];

    final sprites = jsonDecode(spriteString) as Map<String, String>;

    return sprites["front_default"];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'pokemon_v2_pokemonstats':
            pokemonV2Pokemonstats?.map((e) => e.toMap()).toList(),
        'pokemon_v2_pokemonsprites': pokemonV2Pokemonsprites,
        'height': height,
        'weight': weight,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PokemonV2Pokemon].
  factory PokemonV2Pokemon.fromJson(String data) {
    return PokemonV2Pokemon.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PokemonV2Pokemon] to a JSON string.
  String toJson() => json.encode(toMap());

  PokemonV2Pokemon copyWith({
    int? id,
    String? name,
    List<PokemonV2Pokemonstat>? pokemonV2Pokemonstats,
    String? pokemonV2Pokemonsprites,
    int? height,
    int? weight,
  }) {
    return PokemonV2Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      pokemonV2Pokemonstats:
          pokemonV2Pokemonstats ?? this.pokemonV2Pokemonstats,
      pokemonV2Pokemonsprites:
          pokemonV2Pokemonsprites ?? this.pokemonV2Pokemonsprites,
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
      pokemonV2Pokemonstats,
      pokemonV2Pokemonsprites,
      height,
      weight,
    ];
  }
}
