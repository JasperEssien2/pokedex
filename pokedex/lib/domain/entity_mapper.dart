// import 'package:pokedex/data/models/pokemon_v2_pokemon.dart';
// import 'package:pokedex/domain/pokemon_entity.dart';
// import 'package:pokedex/util.dart/extensions.dart';

// abstract class EntityMapper<M, E> {
//   M fromEntity(E entity);

//   E toEntity(M model);
// }

// class ModelToEntityMapper
//     extends EntityMapper<PokemonV2Pokemon, PokemonEntity> {
//   @override
//   PokemonV2Pokemon fromEntity(PokemonEntity entity) =>
//       throw UnimplementedError();

//   @override
//   PokemonEntity toEntity(PokemonV2Pokemon model) {
//     return PokemonEntity(
//       id: model.id!,
//       svgSprite: model.spriteSvg!,
//       name: model.name!.capitilizeFirst,
//       isFavourited: false,
//       type: model.types
//               ?.map((e) => e.pokemonV2Type!.name!.capitilizeFirst)
//               .toList()
//               .join(", ") ??
//           '',
//       attribute: PokemonAttributeEntity(
//         bmi: model.bmi,
//         height: model.height!,
//         weight: model.weight!,
//       ),
//       stats: stats,
//       backgroundColor: backgroundColor,
//     );
//   }
// }
