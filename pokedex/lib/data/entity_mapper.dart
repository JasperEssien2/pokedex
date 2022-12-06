import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_v2_pokemon.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/domain/repository_base.dart';
import 'package:pokedex/util.dart/extensions.dart';

final modelToEntityMapper = _ModelToEntityMapper();
final cacheModelToEntityMapper = _CacheModelToEntityMapper();

abstract class EntityMapper<M, E> {
  M fromEntity(E entity);

  E toEntity(M model);
}

class _ModelToEntityMapper
    extends EntityMapper<PokemonV2Pokemon, PokemonEntity> {
  @override
  PokemonV2Pokemon fromEntity(PokemonEntity entity) =>
      throw UnimplementedError();

  @override
  PokemonEntity toEntity(PokemonV2Pokemon model) {
    return PokemonEntity(
      id: model.id!,
      svgSprite: model.spriteSvg!,
      name: model.name!.capitilizeFirst,
      isFavourited: false,
      type: model.types
              ?.map((e) => e.pokemonV2Type!.name!.capitilizeFirst)
              .toList()
              .join(", ") ??
          '',
      attribute: PokemonAttributeEntity(
        bmi: model.bmi,
        height: model.height!,
        weight: model.weight!,
      ),
      stats: model.stats!
          .map((e) => PokemonStatEntity(
              name: e.pokemonV2Stat!.name!.capitilizeFirst, stat: e.baseStat!))
          .toList()
        ..add(PokemonStatEntity(name: "Avg. Power", stat: model.avgPower)),
      backgroundColor: randomColorGenerator,
    );
  }
}

class _CacheModelToEntityMapper
    extends EntityMapper<CachePokemonModel, PokemonEntity> {
  @override
  CachePokemonModel fromEntity(PokemonEntity entity) {
    return CachePokemonModel(
      stats: entity.stats.map((e) => Stat(name: e.name, stat: e.stat)).toList(),
      types: entity.type,
      id: entity.id,
      name: entity.name,
      height: entity.attribute.height,
      weight: entity.attribute.weight,
      bmi: entity.attribute.bmi,
      sprite: entity.svgSprite,
      color: entity.backgroundColor.toHex(),
    );
  }

  @override
  PokemonEntity toEntity(CachePokemonModel model) => PokemonEntity(
        id: model.id,
        svgSprite: model.sprite,
        name: model.name,
        isFavourited: true,
        type: model.types,
        attribute: PokemonAttributeEntity(
          bmi: model.bmi,
          height: model.height,
          weight: model.weight,
        ),
        stats: model.stats
            .map((e) => PokemonStatEntity(name: e.name, stat: e.stat))
            .toList(),
        backgroundColor: model.color.fromHex,
      );
}

Color get randomColorGenerator {
  const colors = Colors.primaries;

  return colors[Random().nextInt(colors.length)].withOpacity(.15);
}

extension PokemonModelExt on PokemonModel {
  PokemonList get pokemonEntityList =>
      pokemonV2Pokemon?.map((e) => modelToEntityMapper.toEntity(e)).toList() ??
      [];
}

extension CachePokemonExt on List<CachePokemonModel> {
  PokemonList get pokemonEntityList =>
      map((e) => cacheModelToEntityMapper.toEntity(e)).toList();
}

extension PokemonEntityExt on PokemonEntity {
  CachePokemonModel get cachePokemonModel =>
      cacheModelToEntityMapper.fromEntity(this);
}
