import 'package:pokedex/domain/pokemon_entity.dart';

extension NumExt on num {
  String get pokemonId {
    var strId = toString();
    final length = strId.length;

    if (length == 1) {
      strId = strId.padLeft(2, '0');
    } else if (length == 2) {
      strId = strId.padLeft(1, '0');
    }

    return "#$strId";
  }
}

extension PokemonEntityExt on PokemonEntity {
  String get imageTag => "image-$id-$isFavourited";

}
