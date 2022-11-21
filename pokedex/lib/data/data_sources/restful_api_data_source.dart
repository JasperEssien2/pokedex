import 'package:dio/dio.dart' as dio;
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/data/data_sources/data_source.dart';
import 'package:pokedex/data/data_sources/dio_helper.dart';
import 'package:pokedex/data/data_sources/local_dart_source.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_model.dart';

import '../models/pokemon_v2_pokemon.dart';

typedef _ResponseFuture = Either<String, dio.Response<dynamic>>;

class RestfulApiDataSource extends BaseDataSource with LocalDataSource {
  HiveStore? _hiveStore;
  DioHelper _dioHelper = DioHelper();

  final endpoint = "https://pokeapi.co/api/v2/pokemon/";

  @visibleForTesting
  set dioHelper(DioHelper value) {
    _dioHelper = value;
  }

  @visibleForTesting
  void setHiveStore(HiveStore store) {
    _hiveStore = store;
  }

  Future<HiveStore> get hiveStore async {
    return _hiveStore ??= await HiveStore.open(
        path: (await getApplicationDocumentsDirectory()).path);
  }

  @override
  Future<Either<String, PokemonModel>> queryPokemonData(
      {required int offset, int limit = 20}) async {
    final result = await _dioHelper.get(url: endpoint, params: {
      'limit': limit,
      'offset': offset,
    });

    if (result.isLeft) {
      return Left(result.left);
    } else {
      List<PokemonV2Pokemon> pokemons =
          await _fetchPokemonDetailAndParse(result);

      return Right(PokemonModel(pokemonV2Pokemon: pokemons));
    }
  }

  Future<List<PokemonV2Pokemon>> _fetchPokemonDetailAndParse(
      Either<String, dio.Response<dynamic>> result) async {
    final results = result.right.data["results"];

    final futures = <Future<_ResponseFuture>>[];

    for (var result in results) {
      futures.add(_dioHelper.get(url: result["url"]));
    }

    final pokemonInfoFuture = await Future.wait<_ResponseFuture>(futures);

    final pokemons = pokemonInfoFuture.map(
      (e) {
        return PokemonV2Pokemon.fromMapRestAPI(e.right.data);
      },
    ).toList();
    return pokemons;
  }

  @override
  Future<Either<String, List<CachePokemonModel>>> mutateFavouritePokemon(
    CachePokemonModel model,
  ) async {
    final store = await hiveStore;
    return saveFavourite(store, model);
  }

  @override
  Future<Either<String, List<CachePokemonModel>>>
      queryFavouritePokemon() async {
    final store = await hiveStore;
    return fetchFavourites(store);
  }
}
