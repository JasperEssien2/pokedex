import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/data/fake_repository.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/presentation/data_controller.dart';
import 'package:pokedex/presentation/detail_screen.dart';
import 'package:pokedex/presentation/home_screen.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';
import 'package:pokedex/util.dart/util_export.dart';

import 'custom_finders_matchers.dart';
import 'test_utils.dart';

class HomeScreenTestCases {
  HomeScreenTestCases(this.repository);

  final FakeRepository repository;

  Future<void> testCurrentTab(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    _expectCurrentTabIsAllFavourite();

    await _navigateToSecondTab(tester);

    expect(find.byType(PokemonGridView<PokemonDataController>), findsNothing);
    expect(
      find.byType(PokemonGridView<FavoritePokenDataController>),
      findsOneWidget,
    );
  }

  void _expectCurrentTabIsAllFavourite() {
    expect(find.byType(PokemonGridView<PokemonDataController>), findsOneWidget);
    expect(
      find.byType(PokemonGridView<FavoritePokenDataController>),
      findsNothing,
    );
  }

  Future<void> testAllPokemonLoadingState(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    final context = tester.state(find.byType(HomeScreen)).context;

    context.pokemonController.state = const UIState(data: [], loading: true);
    context.pokemonController.nextPage = 1;

    await tester.pump(const Duration(milliseconds: 20));

    _expectOnlyLoadingWidgets();
  }

  Future<void> testAllPokemonBottomLoadingState(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    final context = tester.state(find.byType(HomeScreen)).context;

    await _allPokemonFetch(context, tester);

    context.pokemonController.state = const UIState(data: [], loading: true);

    await tester.pump(const Duration(milliseconds: 20));

    expect(find.byType(BottomLoadingWidget), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);

    expect(find.byType(PokedexCardShimmer), findsNothing);
    expect(find.byType(InfoWidget), findsNothing);
  }

  Future<void> testAllPokemonEmptyState(WidgetTester tester) async {
    repository.returnList = [];

    await TestUtils.pumpApp(tester, repository: repository);

    final context = tester.state(find.byType(HomeScreen)).context;

    await _allPokemonFetch(context, tester);

    expect(
      findInfoWidget(text: "No pokemon found", buttonText: "Retry"),
      findsOneWidget,
    );
    expect(context.pokemonController.nextPage, 1);

    expect(find.byType(BottomLoadingWidget), findsNothing);
    expect(find.byType(PokedexCardShimmer), findsNothing);
    expect(find.byType(GridView), findsNothing);

    final newList = [
      PokemonEntity.dummy(),
      PokemonEntity.dummy().copyWith(id: 5)
    ];

    repository.returnList = newList;

    await tester.tap(find.text("Retry"));

    await tester.pumpAndSettle();

    for (var item in newList) {
      expect(find.byKey(ValueKey(item)), findsOneWidget);
    }

    expect(find.byType(GridView), findsOneWidget);
    expect(context.pokemonController.nextPage, 2);
  }

  Future<void> testAllPokemonSubsequentEmptyState(WidgetTester tester) async {
    repository.returnList = [
      PokemonEntity.dummy().copyWith(id: 12),
      PokemonEntity.dummy().copyWith(id: 92),
    ];

    await TestUtils.pumpApp(tester, repository: repository);

    final context = tester.state(find.byType(HomeScreen)).context;

    await _allPokemonFetch(context, tester);

    repository.nextList = [];
    repository.isNextBatch = true;

    await _allPokemonFetch(context, tester);

    for (var item in repository.nextList!) {
      expect(find.byKey(ValueKey(item)), findsWidgets);
    }

    expect(find.byType(InfoWidget), findsNothing);
  }

  Future<void> testAllPokemonSuccessState(WidgetTester tester) async {
    final newList = [
      PokemonEntity.dummy(),
      PokemonEntity.dummy().copyWith(id: 5)
    ];

    repository.returnList = newList;

    await TestUtils.pumpApp(tester, repository: repository);

    for (var item in newList) {
      expect(find.byKey(ValueKey(item)), findsOneWidget);
    }

    _expectOnlySuccessWidget();
  }

  Future<void> testAllPokemonErrorState(WidgetTester tester) async {
    repository.returnSuccess = false;

    await TestUtils.pumpApp(tester, repository: repository);

    final context = tester.state(find.byType(HomeScreen)).context;

    await _allPokemonFetch(context, tester);

    _expectOnlyErrorWidgets();
  }

  Future<void> testPagination(WidgetTester tester) async {
    repository.returnList = List.generate(
      20,
      (index) => PokemonEntity.dummy().copyWith(id: index),
    );

    await TestUtils.pumpApp(tester, repository: repository);

    final context = tester.state(find.byType(HomeScreen)).context;
    final controller = context.pokemonController;

    expect(controller.nextPage, 2);
    expect(controller.pageOffset, 21);

    repository.nextList = [
      PokemonEntity.dummy().copyWith(id: 542),
      PokemonEntity.dummy().copyWith(id: 492),
    ];

    repository.isNextBatch = true;

    for (var item in repository.nextList!) {
      expect(find.byKey(ValueKey(item)), findsNothing);
    }

    controller.fetch();

    await tester.pumpAndSettle();

    await tester.drag(find.byType(GridView), const Offset(0, -600));

    await tester.pumpAndSettle();

    //TODO: Couldn't get the scroll to work
    // await TestUtils.scrollWidget(
    //   tester,
    //   visibleKey: ValueKey(PokemonEntity.dummy().copyWith(id: 542)),
    // );

    // for (var item in repository.returnList!) {
    //   expect(find.byKey(ValueKey(item)), findsOneWidget);
    // }
    for (var item in repository.nextList!) {
      expect(find.byKey(ValueKey(item)), findsOneWidget);
    }

    expect(controller.nextPage, 3);
    expect(controller.pageOffset, 31);

    await Future.delayed(const Duration(milliseconds: 2900));
  }

  Future<void> testFavouritePokemonLoadingState(WidgetTester tester) async {
    await TestUtils.pumpApp(tester, repository: repository);

    await _navigateToSecondTab(tester);

    final context = tester.state(find.byType(HomeScreen)).context;

    context.favouritePokemonController.state =
        const UIState(data: [], loading: true);
    context.favouritePokemonController.nextPage = 1;

    await tester.pump(const Duration(milliseconds: 20));

    _expectOnlyLoadingWidgets();
  }

  Future<void> testFavouritePokemonEmptyState(WidgetTester tester) async {
    repository.returnList = [];

    await TestUtils.pumpApp(tester, repository: repository);

    await _navigateToSecondTab(tester);

    final context = tester.state(find.byType(HomeScreen)).context;

    context.favouritePokemonController.fetch();

    await tester.pump(const Duration(milliseconds: 20));

    expect(
      findInfoWidget(
        text: 'No favourite pokemons yet',
        buttonText: 'Add Favourite',
      ),
      findsOneWidget,
    );

    expect(find.text("0"), findsNothing);

    expect(find.byType(BottomLoadingWidget), findsNothing);
    expect(find.byType(PokedexCardShimmer), findsNothing);
    expect(find.byType(GridView), findsNothing);

    await tester.tap(find.text("Add Favourite"));

    await tester.pumpAndSettle();

    _expectCurrentTabIsAllFavourite();
  }

  Future<void> testFavouritePokemonSuccessState(WidgetTester tester) async {
    final newList = [
      PokemonEntity.dummy().copyWith(isFavourited: true),
      PokemonEntity.dummy().copyWith(id: 5, isFavourited: true),
      PokemonEntity.dummy().copyWith(id: 45, isFavourited: true)
    ];

    repository.returnList = newList;

    await TestUtils.pumpApp(tester, repository: repository);

    await _navigateToSecondTab(tester);

    for (var item in newList) {
      expect(find.byKey(ValueKey(item)), findsOneWidget);
    }

    _expectOnlySuccessWidget();

    expect(find.text("3"), findsOneWidget);
  }

  Future<void> testFavouritePokemonErrorState(WidgetTester tester) async {
    repository.returnSuccess = false;

    await TestUtils.pumpApp(tester, repository: repository);

    final context = tester.state(find.byType(HomeScreen)).context;

    await _navigateToSecondTab(tester);

    await _favouritePokemonFetch(context, tester);

    _expectOnlyErrorWidgets();
  }

  Future<void> testNavigation(WidgetTester tester) async {
    final List<Route> navigatorEntries = [];

    final TestNavigatorObserver navigatorObserver = TestNavigatorObserver()
      ..onPushed = (route, _) {
        navigatorEntries.add(route);
      };

    await TestUtils.pushDetailScreen(
      tester,
      repository: repository,
      key: ValueKey(PokemonEntity.dummy().copyWith(id: 4)),
      observer: navigatorObserver,
    );

    expect(navigatorEntries.last, MaterialPageRoute<PokemonDetailScreen>);
  }

  void _expectOnlySuccessWidget() {
    expect(find.byType(GridView), findsOneWidget);

    expect(find.byType(BottomLoadingWidget), findsNothing);
    expect(find.byType(PokedexCardShimmer), findsNothing);
    expect(find.byType(InfoWidget), findsNothing);
  }

  void _expectOnlyErrorWidgets() {
    expect(
      findInfoWidget(text: "An error occurred", buttonText: "Retry"),
      findsOneWidget,
    );

    expect(find.byType(BottomLoadingWidget), findsNothing);
    expect(find.byType(PokedexCardShimmer), findsNothing);
    expect(find.byType(GridView), findsNothing);
  }

  void _expectOnlyLoadingWidgets() {
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(PokedexCardShimmer), findsAtLeastNWidgets(9));
    expect(find.byType(BottomLoadingWidget), findsNothing);
    expect(find.byType(InfoWidget), findsNothing);
  }

  Future<void> _navigateToSecondTab(WidgetTester tester) async {
    await tester.tap(find.text("Favourites"));

    await tester.pumpAndSettle();
  }

  Future<void> _allPokemonFetch(
      BuildContext context, WidgetTester tester) async {
    context.pokemonController.fetch();

    await tester.pumpAndSettle();
  }

  Future<void> _favouritePokemonFetch(
      BuildContext context, WidgetTester tester) async {
    context.favouritePokemonController.fetch();

    await tester.pump(const Duration(milliseconds: 20));
  }
}
