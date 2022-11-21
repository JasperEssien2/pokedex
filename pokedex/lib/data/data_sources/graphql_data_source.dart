import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/data/data_sources/local_dart_source.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

import 'data_source.dart';

class GraphQlDataSource extends BaseDataSource
    with GraphQLQueriesText, LocalDataSource {
  final _httpLink = HttpLink('https://beta.pokeapi.co/graphql/v1beta');

  GraphQLClient? _client;

  @visibleForTesting
  set client(GraphQLClient? value) {
    _client = value;
  }

  @visibleForTesting
  Future<GraphQLClient> getClient(
      {@visibleForTesting HiveStore? hiveStore}) async {
    if (_client == null) {
      final store = hiveStore ??
          await HiveStore.open(
              path: (await getApplicationDocumentsDirectory()).path);

      _client = GraphQLClient(
        link: _httpLink,
        cache: GraphQLCache(store: store),
      );
    }
    return _client!;
  }

  @override
  Future<Either<String, PokemonModel>> queryPokemonData({
    required int offset,
    int limit = 20,
  }) async {
    final client = await getClient();

    final options = QueryOptions(
      document: gql(fetchPokemonQueryString),
      variables: {
        'limit': limit,
        'offset': offset,
      },
      parserFn: (data) {
        return PokemonModel.fromMap(data);
      },
    );

    final result = await client.query<PokemonModel>(options);

    if (result.hasException) {
      String errorBuilder = _buildErrorFromGraphQLErrors(result);
      return Left(errorBuilder);
    }

    return Right(result.parserFn(result.data!));
  }

  String _buildErrorFromGraphQLErrors(QueryResult<PokemonModel> result) {
    final graphqlErrors = result.exception!.graphqlErrors;

    String errorBuilder = "";

    for (var error in graphqlErrors) {
      errorBuilder += "${error.message}\n";
    }

    if (errorBuilder.isEmpty) {
      errorBuilder = "An error occurred, please try again";
    }
    return errorBuilder;
  }

  @override
  Future<Either<String, List<CachePokemonModel>>> mutateFavouritePokemon(
      CachePokemonModel model) async {
    final client = await getClient();

    return saveFavourite(client.cache.store, model);
  }

  @override
  Future<Either<String, List<CachePokemonModel>>>
      queryFavouritePokemon() async {
    final client = await getClient();

    return fetchFavourites(client.cache.store);
  }
}

mixin GraphQLQueriesText {
  String get fetchPokemonQueryString {
    return """
  query samplePokeAPIquery(\$limit: Int!, \$offset: Int!) {
    pokemon_v2_pokemon(limit: \$limit, offset: \$offset) {
      id
      name
      pokemon_v2_pokemonstats {
        base_stat
        pokemon_v2_stat {
          name
        }
      }
      pokemon_v2_pokemonsprites {
        sprites
      }
      height
      weight
    }
  }
""";
  }
}
