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
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 80,
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
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 80,
            sprite: 'sprite.svg',
          ).toMap();

          const cacheModel = CachePokemonModel(
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 180,
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
            stats: [Stat(name: "attack", stat: 80)],
            id: 6,
            name: "pokemon",
            height: 40,
            weight: 80,
            sprite: 'sprite.svg',
          ).toMap();

          final result = await dataSource.queryFavouritePokemon();

          expect(
            result.right,
            [
              const CachePokemonModel(
                stats: [Stat(name: "attack", stat: 80)],
                id: 6,
                name: "pokemon",
                height: 40,
                weight: 80,
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
        data: _responseData,
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

Map<String, dynamic> get _responseData {
  return {
    "data": {
      "pokemon_v2_pokemon": [
        {
          "id": 2,
          "name": "ivysaur",
          "pokemon_v2_pokemonstats": [
            {
              "base_stat": 60,
              "pokemon_v2_stat": {"name": "hp"}
            },
            {
              "base_stat": 62,
              "pokemon_v2_stat": {"name": "attack"}
            },
          ],
          "pokemon_v2_pokemonsprites": [
            {
              "sprites":
                  "{\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/2.png\", \"front_shiny_female\": null, \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png\", \"back_female\": null, \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/2.png\", \"back_shiny_female\": null, \"other\": {\"dream_world\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/2.svg\", \"front_female\": null}, \"home\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/2.png\", \"front_shiny_female\": null}, \"official-artwork\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png\"}}, \"versions\": {\"generation-i\": {\"red-blue\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/2.png\", \"front_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/gray/2.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/2.png\", \"back_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/gray/2.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/transparent/2.png\", \"back_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/transparent/back/2.png\"}, \"yellow\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/2.png\", \"front_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/gray/2.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/back/2.png\", \"back_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/back/gray/2.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/transparent/2.png\", \"back_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/transparent/back/2.png\"}}, \"generation-ii\": {\"crystal\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/2.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/shiny/2.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/back/2.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/back/shiny/2.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/2.png\", \"front_shiny_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/shiny/2.png\", \"back_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/back/2.png\", \"back_shiny_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/back/shiny/2.png\"}, \"gold\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/2.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/shiny/2.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/back/2.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/back/shiny/2.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/transparent/2.png\"}, \"silver\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/2.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/shiny/2.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/back/2.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/back/shiny/2.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/transparent/2.png\"}}, \"generation-iii\": {\"emerald\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/emerald/2.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/emerald/shiny/2.png\"}, \"firered-leafgreen\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/2.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/shiny/2.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/back/2.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/back/shiny/2.png\"}, \"ruby-sapphire\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/2.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/shiny/2.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/back/2.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/back/shiny/2.png\"}}, \"generation-iv\": {\"diamond-pearl\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/shiny/2.png\", \"front_shiny_female\": null, \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/2.png\", \"back_female\": null, \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/shiny/2.png\", \"back_shiny_female\": null}, \"heartgold-soulsilver\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/shiny/2.png\", \"front_shiny_female\": null, \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/2.png\", \"back_female\": null, \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/shiny/2.png\", \"back_shiny_female\": null}, \"platinum\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/shiny/2.png\", \"front_shiny_female\": null, \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/2.png\", \"back_female\": null, \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/shiny/2.png\", \"back_shiny_female\": null}}, \"generation-v\": {\"black-white\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/2.png\", \"front_shiny_female\": null, \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/2.png\", \"back_female\": null, \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/2.png\", \"back_shiny_female\": null, \"animated\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/2.gif\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/2.gif\", \"front_shiny_female\": null, \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/2.gif\", \"back_female\": null, \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/2.gif\", \"back_shiny_female\": null}}}, \"generation-vi\": {\"omegaruby-alphasapphire\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/shiny/2.png\", \"front_shiny_female\": null}, \"x-y\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/shiny/2.png\", \"front_shiny_female\": null}}, \"generation-vii\": {\"ultra-sun-ultra-moon\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/2.png\", \"front_female\": null, \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/shiny/2.png\", \"front_shiny_female\": null}, \"icons\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/icons/2.png\", \"front_female\": null}}, \"generation-viii\": {\"icons\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-viii/icons/2.png\", \"front_female\": null}}}}"
            }
          ],
          "pokemon_v2_pokemontypes": [
            {
              "pokemon_v2_type": {"name": "grass"}
            },
            {
              "pokemon_v2_type": {"name": "poison"}
            }
          ],
          "height": 10,
          "weight": 130
        },
        {
          "id": 3,
          "name": "venusaur",
          "pokemon_v2_pokemonstats": [
            {
              "base_stat": 82,
              "pokemon_v2_stat": {"name": "attack"}
            },
            {
              "base_stat": 83,
              "pokemon_v2_stat": {"name": "defense"}
            },
          ],
          "pokemon_v2_pokemonsprites": [
            {
              "sprites":
                  "{\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/3.png\", \"back_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/3.png\", \"back_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/3.png\", \"other\": {\"dream_world\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/3.svg\", \"front_female\": null}, \"home\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/female/3.png\"}, \"official-artwork\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png\"}}, \"versions\": {\"generation-i\": {\"red-blue\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/3.png\", \"front_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/gray/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/3.png\", \"back_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/back/gray/3.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/transparent/3.png\", \"back_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/red-blue/transparent/back/3.png\"}, \"yellow\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/3.png\", \"front_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/gray/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/back/3.png\", \"back_gray\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/back/gray/3.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/transparent/3.png\", \"back_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-i/yellow/transparent/back/3.png\"}}, \"generation-ii\": {\"crystal\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/shiny/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/back/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/back/shiny/3.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/3.png\", \"front_shiny_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/shiny/3.png\", \"back_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/back/3.png\", \"back_shiny_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/crystal/transparent/back/shiny/3.png\"}, \"gold\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/shiny/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/back/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/back/shiny/3.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/gold/transparent/3.png\"}, \"silver\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/shiny/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/back/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/back/shiny/3.png\", \"front_transparent\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-ii/silver/transparent/3.png\"}}, \"generation-iii\": {\"emerald\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/emerald/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/emerald/shiny/3.png\"}, \"firered-leafgreen\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/shiny/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/back/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/back/shiny/3.png\"}, \"ruby-sapphire\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/shiny/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/back/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/ruby-sapphire/back/shiny/3.png\"}}, \"generation-iv\": {\"diamond-pearl\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/shiny/female/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/3.png\", \"back_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/female/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/shiny/3.png\", \"back_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/diamond-pearl/back/shiny/female/3.png\"}, \"heartgold-soulsilver\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/shiny/female/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/3.png\", \"back_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/female/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/shiny/3.png\", \"back_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/heartgold-soulsilver/back/shiny/female/3.png\"}, \"platinum\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/shiny/female/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/3.png\", \"back_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/female/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/shiny/3.png\", \"back_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iv/platinum/back/shiny/female/3.png\"}}, \"generation-v\": {\"black-white\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/female/3.png\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/3.png\", \"back_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/female/3.png\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/3.png\", \"back_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/female/3.png\", \"animated\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/3.gif\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/3.gif\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/3.gif\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/3.gif\", \"back_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/3.gif\", \"back_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/3.gif\", \"back_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/3.gif\", \"back_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/3.gif\"}}}, \"generation-vi\": {\"omegaruby-alphasapphire\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/omegaruby-alphasapphire/shiny/female/3.png\"}, \"x-y\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vi/x-y/shiny/female/3.png\"}}, \"generation-vii\": {\"ultra-sun-ultra-moon\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/3.png\", \"front_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/female/3.png\", \"front_shiny\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/shiny/3.png\", \"front_shiny_female\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/ultra-sun-ultra-moon/shiny/female/3.png\"}, \"icons\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/icons/3.png\", \"front_female\": null}}, \"generation-viii\": {\"icons\": {\"front_default\": \"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-viii/icons/3.png\", \"front_female\": null}}}}"
            }
          ],
          "height": 20,
          "weight": 1000
        }
      ]
    }
  };
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
