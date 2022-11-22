import 'dart:convert';

import 'package:equatable/equatable.dart';

class CachePokemonModel extends Equatable {
  final List<Stat> stats;
  final int id;
  final String name;
  final num height;
  final num weight;
  final num bmi;
  final String sprite;
  final String types;
  final String color;

  const CachePokemonModel({
    required this.stats,
    required this.types,
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.sprite,
    required this.color,
  });

  CachePokemonModel copyWith({
    List<Stat>? stats,
    int? id,
    String? name,
    num? height,
    num? weight,
    num? bmi,
    String? sprite,
    String? types,
    String? color,
  }) {
    return CachePokemonModel(
      stats: stats ?? this.stats,
      id: id ?? this.id,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bmi: bmi ?? this.bmi,
      sprite: sprite ?? this.sprite,
      types: types ?? this.types,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stats': stats.map((x) => x.toMap()).toList(),
      'id': id,
      'name': name,
      'bmi': bmi,
      'height': height,
      'weight': weight,
      'types': types,
      'sprite': sprite,
      'color': color,
    };
  }

  factory CachePokemonModel.fromMap(Map<dynamic, dynamic> map) {
    return CachePokemonModel(
      stats: List<Stat>.from(map['stats']?.map((x) => Stat.fromMap(x))),
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      height: map['height'],
      weight: map['weight'],
      sprite: map['sprite'] ?? '',
      types: map['types'] ?? '',
      color: map['color'] ?? '',
      bmi: map['bmi'],
    );
  }

  @override
  String toString() {
    return 'CachePokemonModel(stats: $stats, types: $types, id: $id, name: $name, bmi: $bmi, height: $height, weight: $weight, sprite: $sprite), color: $color';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        bmi,
        height,
        weight,
        sprite,
        stats,
        types,
      ];
}

class Stat extends Equatable {
  const Stat({
    required this.name,
    required this.stat,
  });

  final String name;
  final num stat;

  Stat copyWith({
    String? name,
    num? stat,
  }) {
    return Stat(
      name: name ?? this.name,
      stat: stat ?? this.stat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'stat': stat,
    };
  }

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      name: map['name'] ?? '',
      stat: map['stat'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Stat.fromJson(String source) => Stat.fromMap(json.decode(source));

  @override
  String toString() => 'Stat(name: $name, stat: $stat)';

  @override
  List<Object?> get props => [name, stat];
}
