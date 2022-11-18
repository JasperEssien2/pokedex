import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PokemonEntity implements EquatableMixin {
  PokemonEntity({
    required this.id,
    required this.svgSprite,
    required this.name,
    required this.isFavourited,
    required this.type,
    required this.attribute,
    required this.stats,
    required this.backgroundColor,
  });

  final int id;
  final String svgSprite;
  final String name;
  final bool isFavourited;
  final String type;
  final PokemonAttributeEntity attribute;
  final List<PokemonStatEntity> stats;
  final Color backgroundColor;

  PokemonEntity.dummy()
      : id = 2,
        svgSprite =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
        name = "Bulbasaur",
        type = "Poison",
        isFavourited = true,
        attribute = PokemonAttributeEntity.dummy(),
        stats = List.generate(
          5,
          (index) => PokemonStatEntity.dummy().copyWith(name: "Name $index"),
        ),
        backgroundColor = Colors.blue.withOpacity(.1);

  @override
  List<Object?> get props => [
        id,
        svgSprite,
        name,
        isFavourited,
        type,
        attribute,
        stats,
        backgroundColor
      ];

  @override
  bool? get stringify => true;

  PokemonEntity copyWith({
    int? id,
    String? svgSprite,
    String? name,
    bool? isFavourited,
    String? type,
    PokemonAttributeEntity? attribute,
    List<PokemonStatEntity>? stats,
    Color? backgroundColor,
  }) {
    return PokemonEntity(
      id: id ?? this.id,
      svgSprite: svgSprite ?? this.svgSprite,
      name: name ?? this.name,
      isFavourited: isFavourited ?? this.isFavourited,
      type: type ?? this.type,
      attribute: attribute ?? this.attribute,
      stats: stats ?? this.stats,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

class PokemonAttributeEntity implements EquatableMixin {
  PokemonAttributeEntity({
    required this.weight,
    required this.height,
    required this.bmi,
  });

  final num weight;
  final num height;
  final num bmi;

  PokemonAttributeEntity.dummy()
      : weight = 120,
        height = 40,
        bmi = 10;

  @override
  List<Object?> get props => [weight, height, bmi];

  @override
  bool? get stringify => true;

  PokemonAttributeEntity copyWith({
    num? weight,
    num? height,
    num? bmi,
  }) {
    return PokemonAttributeEntity(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmi: bmi ?? this.bmi,
    );
  }
}

class PokemonStatEntity implements EquatableMixin {
  PokemonStatEntity({required this.name, required this.stat});

  final String name;
  final num stat;

  PokemonStatEntity.dummy()
      : name = "hp",
        stat = 50;

  @override
  List<Object?> get props => [name, stat];

  @override
  bool? get stringify => true;

  PokemonStatEntity copyWith({
    String? name,
    num? stat,
  }) {
    return PokemonStatEntity(
      name: name ?? this.name,
      stat: stat ?? this.stat,
    );
  }
}
