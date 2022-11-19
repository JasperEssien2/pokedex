import 'package:either_dart/either.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/domain/repository_base.dart';

class FakeRepository implements RepositoryBase {
  bool returnSuccess = true;
  PokemonList? returnList;
  PokemonList? nextList;

  @override
  Future<Either<String, PokemonList>> fetchPokemons(
      {required int offset, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (returnSuccess) {
      return Right(offset > 1
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
       returnList ?? List.generate(
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
