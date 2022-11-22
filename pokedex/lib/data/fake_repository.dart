import 'package:either_dart/either.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/domain/repository_base.dart';

class FakeRepository implements RepositoryBase {
  bool returnSuccess = true;
  PokemonList? returnList;
  PokemonList? favouritesReturnList;

  PokemonList? nextList;
  bool isNextBatch = false;

  @override
  Future<Either<String, PokemonList>> fetchPokemons(
      {required int offset, int limit = 20}) async {
    if (returnSuccess) {
      return Right(isNextBatch
          ? nextList ?? []
          : returnList ??
              List.generate(
                20,
                (index) => PokemonEntity.dummy().copyWith(id: index * offset),
              ));
    } else {
      return const Left("An error occurred");
    }
  }

  @override
  Future<Either<String, PokemonList>> saveFavourite(PokemonEntity entity) {
    return fetchFavouritePokemons();
  }

  @override
  Future<Either<String, PokemonList>> fetchFavouritePokemons() async {
    if (returnSuccess) {
      return Right(
        (favouritesReturnList ?? returnList) ??
            List.generate(
              20,
              (index) =>
                  PokemonEntity.dummy().copyWith(id: index, isFavourited: true),
            ),
      );
    } else {
      return const Left("An error occurred");
    }
  }
}
