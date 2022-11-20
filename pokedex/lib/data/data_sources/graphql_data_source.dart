import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

class GraphQlDataSource with GraphQLQueriesText {
  final _httpLink = HttpLink('https://beta.pokeapi.co/graphql/v1beta');

  late GraphQLClient? _client;

  @visibleForTesting
  set client(GraphQLClient? value) {
    _client = value;
  }

  @visibleForTesting
  Future<GraphQLClient> getClient() async {
    if (_client == null) {
      final store = await HiveStore.open();

      _client =
          GraphQLClient(link: _httpLink, cache: GraphQLCache(store: store));
    }
    return _client!;
  }

  Future<Either<String, PokemonModel>> fetchPokenData({
    required int offset,
    int limit = 20,
  }) async {
    final client = await getClient();

    final options = QueryOptions(
      document: gql(
        fetchPokemonQueryString(limit: limit, offset: offset),
      ),
      variables: {
        'limit': limit,
        'offset': offset,
      },
      parserFn: (data) => PokemonModel.fromMap(data),
    );

    final result = await client.query<PokemonModel>(options);

    if (result.hasException) {
      log("GRAPHQL ERROR ============ ${result.exception?.graphqlErrors.map((e) => "${e.message}\n").toList()}");
      log("LINK ERROR ============ ${result.exception?.linkException.toString()}");
      return Left(result.exception.toString());
    }

    return Right(result.parsedData!);
  }

  // Future<Either<String, List<CachePokemonModel>>> queryFavouritePokemon(
  //     CachePokemonModel model) {}

  // Future<Either<String, List<CachePokemonModel>>> fetchFavouritePokemon(
  //     CachePokemonModel model) {}
}

mixin GraphQLQueriesText {
  String fetchPokemonQueryString({required int limit, required int offset}) {
    return """
  query samplePokeAPIquery {
    pokemon_v2_pokemon(limit: $limit, offset: $offset) {
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
