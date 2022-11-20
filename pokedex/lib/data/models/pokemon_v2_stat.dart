import 'package:equatable/equatable.dart';

class PokemonV2Stat extends Equatable {
  final String? name;

  const PokemonV2Stat({this.name});

  factory PokemonV2Stat.fromMap(Map<String, dynamic> data) => PokemonV2Stat(
        name: data['name'] as String?,
      );

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
