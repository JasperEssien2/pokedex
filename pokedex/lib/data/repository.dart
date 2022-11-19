import 'package:either_dart/either.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/domain/repository_base.dart';

class Repository implements RepositoryBase {
  @override
  Future<Either<String, PokemonList>> fetchPokemons(
      {required int offset, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return Right(List.generate(
      20,
      (index) => PokemonEntity.dummy().copyWith(id: index),
    ));
  }

  @override
  Future<Either<String, PokemonList>> saveFavourite(PokemonEntity entity) {
    return fetchFavouritePokemons();
  }

  @override
  Future<Either<String, PokemonList>> fetchFavouritePokemons() async {
    return Right(
      List.generate(
        20,
        (index) =>
            PokemonEntity.dummy().copyWith(id: index, isFavourited: true),
      ),
    );
  }
}
