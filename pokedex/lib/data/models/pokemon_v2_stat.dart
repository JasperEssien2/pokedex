import 'dart:convert';

import 'package:equatable/equatable.dart';

class PokemonV2Stat extends Equatable {
  final String? name;

  const PokemonV2Stat({this.name});

  factory PokemonV2Stat.fromMap(Map<String, dynamic> data) => PokemonV2Stat(
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PokemonV2Stat].
  factory PokemonV2Stat.fromJson(String data) {
    return PokemonV2Stat.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PokemonV2Stat] to a JSON string.
  String toJson() => json.encode(toMap());

  PokemonV2Stat copyWith({
    String? name,
  }) {
    return PokemonV2Stat(
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name];
}
