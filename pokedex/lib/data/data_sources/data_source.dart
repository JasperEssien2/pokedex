import 'package:either_dart/either.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

abstract class BaseDataSource {
  Future<Either<String, PokemonModel>> queryPokemonData({
    required int offset,
    int limit = 20,
  });

  Future<Either<String, List<CachePokemonModel>>> mutateFavouritePokemon(
      CachePokemonModel model);

  Future<Either<String, List<CachePokemonModel>>> queryFavouritePokemon();
}
