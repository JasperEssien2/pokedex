import 'package:either_dart/src/either.dart';
import 'package:pokedex/data/data_sources/graphql_data_source.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/domain/repository_base.dart';

class RepositoryImpl extends RepositoryBase {
  RepositoryImpl({required GraphQlDataSource dataSource})
      : _dataSource = dataSource;

  final GraphQlDataSource _dataSource;

  @override
  Future<Either<String, PokemonList>> fetchFavouritePokemons() {
    // TODO: implement fetchFavouritePokemons
    throw UnimplementedError();
  }

  @override
  Future<Either<String, PokemonList>> fetchPokemons(
      {required int offset, int limit = 20}) {
    // TODO: implement fetchPokemons
    throw UnimplementedError();
  }

  @override
  Future<Either<String, PokemonList>> saveFavourite(PokemonEntity entity) {
    // TODO: implement saveFavourite
    throw UnimplementedError();
  }
}
