import 'package:either_dart/either.dart';
import 'package:pokedex/data/data_sources/graphql_data_source.dart';
import 'package:pokedex/domain/domain_export.dart';

class RepositoryImpl extends RepositoryBase {
  RepositoryImpl({required GraphQlDataSource dataSource})
      : _dataSource = dataSource;

  final GraphQlDataSource _dataSource;

  @override
  Future<Either<String, PokemonList>> fetchPokemons(
      {required int offset, int limit = 20}) async {
    final result =
        await _dataSource.queryPokemonData(offset: offset, limit: limit);

    return result.map<PokemonList>((right) => right.pokemonEntityList);
  }

  @override
  Future<Either<String, PokemonList>> fetchFavouritePokemons() async {
    final result = await _dataSource.queryFavouritePokemon();

    return result.map<PokemonList>((right) => right.pokemonEntityList);
  }

  @override
  Future<Either<String, PokemonList>> saveFavourite(
      PokemonEntity entity) async {
    final result =
        await _dataSource.mutateFavouritePokemon(entity.cachePokemonModel);

    return result.map<PokemonList>((right) => right.pokemonEntityList);
  }
}
