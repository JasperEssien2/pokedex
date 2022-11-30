import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:graphql/client.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';

mixin LocalDataSource {
  Either<String, List<CachePokemonModel>> saveFavourite(
      Store store, CachePokemonModel model) {
    final id = model.id.toString();

    final pokemon = store.get(id);

    if (pokemon == null) {
      store.put(id, model.toMap());
    } else {
      store.delete(id);
    }

    return fetchFavourites(store);
  }

  Either<String, List<CachePokemonModel>> fetchFavourites(Store store) {
    try {
      final list = <CachePokemonModel>[];

      final map = store.toMap();

      map.forEach((key, value) {
        final map = store.get(key)!;
        final decodedMap = jsonDecode(jsonEncode(map));

        list.add(CachePokemonModel.fromMap(decodedMap));
      });

      return Right(list);
    } catch (e) {
      return const Left("An error occurred fetching favourite pokemons");
    }
  }
}
