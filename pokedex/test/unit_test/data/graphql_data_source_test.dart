import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/data/data_sources/graphql_data_source.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_type.dart';
import 'package:pokedex/data/models/pokemon_v2_pokemon.dart';
import 'package:pokedex/data/models/pokemon_v2_pokemonstat.dart';
import 'package:pokedex/data/models/pokemon_v2_stat.dart';

import 'raw_map_json.dart';

class MockedGraphQLClient extends Mock implements GraphQLClient {}

class FakeQueryOptions extends Fake implements QueryOptions<PokemonModel> {}

class MockedHiveStore extends Mock implements HiveStore {}

void main() {
  registerFallbackValue(FakeQueryOptions());

  late GraphQlDataSource dataSource;
  late MockedGraphQLClient client;
  late InMemoryStoreFake store;
  late Map<String, dynamic> cacheMap;

  setUp(
    () {
      dataSource = GraphQlDataSource();
      client = MockedGraphQLClient();
      cacheMap = {};

      store = InMemoryStoreFake(cacheMap);
      when(() => client.cache).thenReturn(GraphQLCache(store: store));
    },
  );

  group(
    "Test queryPokenData()",
    () {
      test(
        " Ensure that clients return data when successful",
        () async {
          QueryOptions<PokemonModel> options = _dummyQueryOptions();

          _whenQuerySuccess(client, options);

          dataSource.client = client;

          final result = await dataSource.queryPokemonData(offset: 1);

          expect(result.right, _pokemonJsonReplica);
          expect(() => result.left, throwsException);
        },
      );

      test(
        " Ensure that error is returned when request fails",
        () async {
          QueryOptions<PokemonModel> options = _dummyQueryOptions();

          _whenQueryError(client, options);

          dataSource.client = client;

          final result = await dataSource.queryPokemonData(offset: 1);

          expect(result.left, "GraphQL error occurred\n");
          expect(() => result.right, throwsException);
        },
      );

      test(
        " Ensure that default error text is returned when request fails with an empty message",
        () async {
          QueryOptions<PokemonModel> options = _dummyQueryOptions();

          _whenQueryError(client, options, errors: []);

          dataSource.client = client;

          final result = await dataSource.queryPokemonData(offset: 1);

          expect(result.left, "An error occurred, please try again");
          expect(() => result.right, throwsException);
        },
      );
    },
  );

  group(
    "Test mutateFavouritePokemon()",
    () {
      test(
        "Ensure pokemon is added, when data doesn't exist",
        () async {
          dataSource.client = client;

          const cacheModel = CachePokemonModel(
            types: "Poison",
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 80,
            bmi: 120,
            color: "#000",
            sprite: 'sprite.svg',
          );

          final result = await dataSource.mutateFavouritePokemon(cacheModel);

          expect(result.right, [cacheModel.copyWith()]);
        },
      );

      test(
        "Ensure pokemon is deleted, when data with same ID already exist",
        () async {
          dataSource.client = client;

          cacheMap["6"] = const CachePokemonModel(
            types: "Poison",
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 80,
            bmi: 120,
            color: "#000",
            sprite: 'sprite.svg',
          ).toMap();

          const cacheModel = CachePokemonModel(
            types: "Poison",
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 180,
            bmi: 120,
            color: "#000",
            sprite: 'dsd_sprite.svg',
          );

          final result = await dataSource.mutateFavouritePokemon(cacheModel);

          expect(result.right, []);
        },
      );

      test(
        "Ensure cached pokemon is returned, when queryFavouritePokemon()",
        () async {
          dataSource.client = client;
          cacheMap["6"] = const CachePokemonModel(
            types: "Poison",
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 80,
            bmi: 120,
            color: "#000",
            sprite: 'sprite.svg',
          ).toMap();

          final result = await dataSource.queryFavouritePokemon();

          expect(
            result.right,
            [
              const CachePokemonModel(
                types: "Poison",
                stats: [Stat(name: "attack", stat: 80)],
                id: 6,
                name: "pokemon",
                height: 40,
                weight: 80,
                bmi: 120,
                color: "#000",
                sprite: 'sprite.svg',
              ),
            ],
          );
        },
      );
    },
  );

  group(
    "Test getClient()",
    () {
      test(
        "Ensure getClient() is initiated when null",
        () async {
          final client = await dataSource.getClient(
            hiveStore: MockedHiveStore(),
          );

          expect(client, isNotNull);

          expect(
            client.link,
            isA<HttpLink>(),
          );
        },
      );
    },
  );
}

void _whenQuerySuccess(
    MockedGraphQLClient client, QueryOptions<PokemonModel> options) {
  when(() => client.query<PokemonModel>(any())).thenAnswer(
    (_) => Future.value(
      QueryResult(
        options: options,
        data: pokemonResponseDataRaw,
        source: QueryResultSource.network,
      ),
    ),
  );
}

void _whenQueryError(
    MockedGraphQLClient client, QueryOptions<PokemonModel> options,
    {List<GraphQLError>? errors}) {
  when(() => client.query<PokemonModel>(any())).thenAnswer(
    (_) => Future.value(
      QueryResult(
        options: options,
        exception: OperationException(
            graphqlErrors: errors ??
                [
                  const GraphQLError(
                    message: "GraphQL error occurred",
                  )
                ]),
        source: QueryResultSource.network,
      ),
    ),
  );
}

QueryOptions<PokemonModel> _dummyQueryOptions() {
  final options = QueryOptions(
    document: gql(fetchPokemonQueryString),
    variables: const {
      'limit': 10,
      'offset': 1,
    },
    parserFn: (data) => PokemonModel.fromMap(data),
  );
  return options;
}

PokemonModel get _pokemonJsonReplica {
  return PokemonModel(
    pokemonV2Pokemon: [
      PokemonV2Pokemon(
        id: 2,
        name: "ivysaur",
        stats: [
          _generateStat("hp", 60),
          _generateStat("attack", 62),
        ],
        types: const [
          PokemonV2PokemonType(pokemonV2Type: PokemonV2Type(name: "grass")),
          PokemonV2PokemonType(pokemonV2Type: PokemonV2Type(name: "poison")),
        ],
        spriteSvg:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/2.svg",
        height: 10,
        weight: 130,
      ),
      PokemonV2Pokemon(
        id: 3,
        name: "venusaur",
        stats: [
          _generateStat("attack", 82),
          _generateStat("defense", 83),
        ],
        spriteSvg:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/3.svg",
        height: 20,
        weight: 1000,
      ),
    ],
  );
}

PokemonV2PokemonStat _generateStat(String name, num value) {
  return PokemonV2PokemonStat(
    baseStat: value,
    pokemonV2Stat: PokemonV2Stat(name: name),
  );
}

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

class InMemoryStoreFake extends Store {
  InMemoryStoreFake(this.cache);

  final Map<String, dynamic> cache;

  @override
  void delete(String dataId) {
    cache.remove(dataId);
  }

  @override
  Map<String, dynamic>? get(String dataId) {
    return cache[dataId];
  }

  @override
  void put(String dataId, Map<String, dynamic>? value) {
    cache[dataId] = value;
  }

  @override
  void putAll(Map<String, Map<String, dynamic>?> data) {
    cache.addAll(data);
  }

  @override
  void reset() {
    cache.clear();
  }

  @override
  Map<String, Map<String, dynamic>?> toMap() => Map.unmodifiable(cache);
}
