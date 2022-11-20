import 'dart:convert';

import 'package:equatable/equatable.dart';

class CachePokemonModel extends Equatable {
  final List<Stat> stats;
  final int id;
  final String name;
  final num height;
  final num weight;
  final String sprite;

  const CachePokemonModel({
    required this.stats,
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.sprite,
  });

  CachePokemonModel copyWith({
    List<Stat>? stats,
    int? id,
    String? name,
    num? height,
    num? weight,
    String? sprite,
  }) {
    return CachePokemonModel(
      stats: stats ?? this.stats,
      id: id ?? this.id,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      sprite: sprite ?? this.sprite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stats': stats.map((x) => x.toMap()).toList(),
      'id': id,
      'name': name,
      'height': height,
      'weight': weight,
      'sprite': sprite,
    };
  }

  factory CachePokemonModel.fromMap(Map<String, dynamic> map) {
    return CachePokemonModel(
      stats: List<Stat>.from(map['stats']?.map((x) => Stat.fromMap(x))),
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
      sprite: map['sprite'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CachePokemonModel(stats: $stats, id: $id, name: $name, height: $height, weight: $weight, sprite: $sprite)';
  }

  @override
  List<Object?> get props => [id, name, height, weight, sprite, stats];
}

class Stat extends Equatable {
  const Stat({
    required this.name,
    required this.stat,
  });

  final String name;
  final double stat;

  Stat copyWith({
    String? name,
    double? stat,
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
      stat: map['stat']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Stat.fromJson(String source) => Stat.fromMap(json.decode(source));

  @override
  String toString() => 'Stat(name: $name, stat: $stat)';

  @override
  List<Object?> get props => [name, stat];
}
