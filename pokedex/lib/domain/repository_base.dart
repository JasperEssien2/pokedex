import 'package:either_dart/either.dart';
import 'package:pokedex/domain/pokemon_entity.dart';

typedef PokemonList = List<PokemonEntity>;

abstract class RepositoryBase {
  Future<Either<String, PokemonList>> fetchPokemons(
      {required int offset, int limit = 20});

  Future<Either<String, PokemonList>> fetchFavouritePokemons();

  Future<Either<String, PokemonList>> saveFavourite(PokemonEntity entity);
}
