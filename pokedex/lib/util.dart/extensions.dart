import 'package:pokedex/domain/pokemon_entity.dart';

extension NumExt on num {
  String get pokemonId {
    var strId = toString();

    if (this < 10) {
      strId = strId.padLeft(3, '0');
    } else if (this < 100) {
      strId = strId.padLeft(3, '0');
    }

    return "#$strId";
  }
}

extension PokemonEntityExt on PokemonEntity {
  String get imageTag => "image-$id-$isFavourited";
}
