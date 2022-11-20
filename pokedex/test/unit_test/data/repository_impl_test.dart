import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/data/data_sources/graphql_data_source.dart';
import 'package:pokedex/data/models/cache_pokemon_model.dart';
import 'package:pokedex/data/models/pokemon_model.dart';
import 'package:pokedex/data/repository_impl.dart';
import 'package:pokedex/domain/domain_export.dart';
import 'package:pokedex/util.dart/util_export.dart';

import 'raw_map_json.dart';

class MockedGraphQlDataSource extends Mock implements GraphQlDataSource {}

class FakeCachePokemonModel extends Fake implements CachePokemonModel {}

class FakePokemonEntity extends Fake implements PokemonEntity {}

void main() {
  late RepositoryImpl repository;
  late MockedGraphQlDataSource dataSource;

  registerFallbackValue(FakeCachePokemonModel());
  registerFallbackValue(FakePokemonEntity());

  setUp(
    () {
      dataSource = MockedGraphQlDataSource();
      repository = RepositoryImpl(dataSource: dataSource);
    },
  );

  _testGroup<PokemonModel>(
    "fetchPokemons()",
    whenSuccess: () => when(() => dataSource.queryPokemonData(
        offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer(
      (_) => Future.value(
        Right(
          PokemonModel.fromMap(pokemonResponseDataRaw["data"]),
        ),
      ),
    ),
    whenError: () => when(
      () => dataSource.queryPokemonData(
        offset: any(named: 'offset'),
        limit: any(named: 'limit'),
      ),
    ),
    performAction: () => repository.fetchPokemons(offset: 2, limit: 20),
    expectPokemonList: _pokemonQueryExpectedSuccessList,
    verifyCall: () => dataSource.queryPokemonData(offset: 2, limit: 20),
  );

  _testGroup<List<CachePokemonModel>>(
    "fetchFavouritePokemons()",
    whenSuccess: () =>
        when(() => dataSource.queryFavouritePokemon()).thenAnswer(
      (_) => _futureCachePokemonList,
    ),
    whenError: () => when(
      () => dataSource.queryFavouritePokemon(),
    ),
    performAction: () => repository.fetchFavouritePokemons(),
    expectPokemonList: _expectedPokemonlistFromCache,
    verifyCall: () => dataSource.queryFavouritePokemon(),
  );

  _testGroup<List<CachePokemonModel>>(
    "saveFavourite()",
    whenSuccess: () =>
        when(() => dataSource.mutateFavouritePokemon(any())).thenAnswer(
      (_) => _futureCachePokemonList,
    ),
    whenError: () => when(
      () => dataSource.mutateFavouritePokemon(any()),
    ),
    performAction: () => repository.saveFavourite(PokemonEntity.dummy()),
    expectPokemonList: _expectedPokemonlistFromCache,
    verifyCall: () => dataSource.mutateFavouritePokemon(
      PokemonEntity.dummy().cachePokemonModel,
    ),
  );

  test(
    "Ensure ModelToEntity fromEntity() throws error",
    () {
      expect(
        () => modelToEntityMapper.fromEntity(PokemonEntity.dummy()),
        throwsUnimplementedError,
      );
    },
  );
}

List<PokemonEntity> get _expectedPokemonlistFromCache {
  return [
    const PokemonEntity(
      id: 2,
      svgSprite: "sprite.svg",
      name: "Fan-bolt",
      isFavourited: true,
      type: "Power",
      attribute: PokemonAttributeEntity(
        height: 40,
        weight: 130,
        bmi: 3.5,
      ),
      stats: [],
      backgroundColor: Colors.red,
    ),
  ];
}

Future<Either<String, List<CachePokemonModel>>> get _futureCachePokemonList {
  return Future.value(
    Right(
      [
        CachePokemonModel(
          stats: const [],
          types: "Power",
          id: 2,
          name: "Fan-bolt",
          height: 40,
          weight: 130,
          bmi: 3.5,
          sprite: "sprite.svg",
          color: Colors.red.toHex(),
        )
      ],
    ),
  );
}

List<PokemonEntity> get _pokemonQueryExpectedSuccessList {
  return [
    PokemonEntity(
      id: 2,
      svgSprite:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/2.svg",
      name: "Ivysaur",
      isFavourited: false,
      type: "Grass, Poison",
      attribute: const PokemonAttributeEntity(height: 10, weight: 130, bmi: 1),
      stats: const [
        PokemonStatEntity(name: 'Hp', stat: 60),
        PokemonStatEntity(name: 'Attack', stat: 62),
        PokemonStatEntity(name: 'Avg. Power', stat: 20),
      ],
      backgroundColor: Colors.blue.withOpacity(.1),
    ),
    const PokemonEntity(
      id: 3,
      svgSprite:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/3.svg",
      name: "Venusaur",
      isFavourited: false,
      type: "",
      attribute: PokemonAttributeEntity(height: 20, weight: 1000, bmi: 3),
      stats: [
        PokemonStatEntity(name: 'Attack', stat: 82),
        PokemonStatEntity(name: 'Defense', stat: 83),
        PokemonStatEntity(name: 'Avg. Power', stat: 28),
      ],
      backgroundColor: Colors.white,
    ),
  ];
}

void _testGroup<T>(
  String testCategory, {
  required void Function() whenSuccess,
  required When Function() whenError,
  required Future<Either<String, PokemonList>> Function() performAction,
  required PokemonList expectPokemonList,
  required Function verifyCall,
  String error = "An error occurred",
}) {
  group(
    "Test $testCategory",
    () {
      test(
        "Ensure that data from source is mapped to PokemonList correctly when request successful",
        () async {
          whenSuccess();

          final result = await performAction();

          expect(result.right, expectPokemonList);
          expect(() => result.left, throwsException);
          verify(() => verifyCall());
        },
      );

      test(
        "Ensure that error is returned when request fails",
        () async {
          whenError().thenAnswer((_) => Future.value(Left<String, T>(error)));

          final result = await performAction();

          expect(result.left, error);
          expect(() => result.right, throwsException);

          verify(() => verifyCall());
        },
      );
    },
  );
}
