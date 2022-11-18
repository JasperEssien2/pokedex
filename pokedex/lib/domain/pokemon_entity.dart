import 'package:equatable/equatable.dart';

class PokemonEntity implements EquatableMixin {
  PokemonEntity(
    this.id,
    this.svgSprite,
    this.name,
    this.isFavourited,
    this.type,
    this.attribute,
    this.stats,
  );

  final int id;
  final String svgSprite;
  final String name;
  final bool isFavourited;
  final String type;
  final PokemonAttributeEntity attribute;
  final PokemonStatsEntity stats;

  PokemonEntity.dummy()
      : id = 2,
        svgSprite = 's.svg',
        name = "Bulbasaur",
        type = "Poison",
        isFavourited = true,
        attribute = PokemonAttributeEntity.dummy(),
        stats = PokemonStatsEntity.dummy();

  @override
  List<Object?> get props => [
        id,
        svgSprite,
        name,
        isFavourited,
        type,
        attribute,
        stats,
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
    PokemonStatsEntity? stats,
  }) {
    return PokemonEntity(
      id ?? this.id,
      svgSprite ?? this.svgSprite,
      name ?? this.name,
      isFavourited ?? this.isFavourited,
      type ?? this.type,
      attribute ?? this.attribute,
      stats ?? this.stats,
    );
  }
}

class PokemonAttributeEntity implements EquatableMixin {
  PokemonAttributeEntity(this.weight, this.height, this.bmi);

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
      weight ?? this.weight,
      height ?? this.height,
      bmi ?? this.bmi,
    );
  }
}

class PokemonStatsEntity implements EquatableMixin {
  PokemonStatsEntity(this.hp, this.attack, this.defense, this.specialAttack,
      this.specialDefense, this.speed, this.avgPower);

  final num hp;
  final num attack;
  final num defense;
  final num specialAttack;
  final num specialDefense;
  final num speed;
  final num avgPower;

  PokemonStatsEntity.dummy()
      : hp = 20,
        attack = 40,
        defense = 10,
        specialAttack = 5,
        specialDefense = 80,
        speed = 34,
        avgPower = 100;

  @override
  List<Object?> get props =>
      [hp, attack, defense, specialAttack, specialDefense, speed, avgPower];

  @override
  bool? get stringify => true;

  PokemonStatsEntity copyWith({
    num? hp,
    num? attack,
    num? defense,
    num? specialAttack,
    num? specialDefense,
    num? speed,
    num? avgPower,
  }) {
    return PokemonStatsEntity(
      hp ?? this.hp,
      attack ?? this.attack,
      defense ?? this.defense,
      specialAttack ?? this.specialAttack,
      specialDefense ?? this.specialDefense,
      speed ?? this.speed,
      avgPower ?? this.avgPower,
    );
  }
}
