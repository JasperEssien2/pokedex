import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/data/fake_repository.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/presentation/detail_screen.dart';

import 'custom_finders_matchers.dart';
import 'test_utils.dart';

class DetailScreenTestCases {
  DetailScreenTestCases(this.repository);

  final FakeRepository repository;

  Future<void> testAppBar(WidgetTester tester) async {
    repository.returnList = [PokemonEntity.dummy()];

    final expectedPokemon = PokemonEntity.dummy();

    await _pumpAndOpenDetailScreen(tester, expectedPokemon);

    expect(
      find.byType(DetailAppBar),
      findsOneWidget,
    );
    expect(find.text("#002"), findsOneWidget);
    expect(find.text("Bulbasaur"), findsOneWidget);
    expect(find.text("Poison"), findsOneWidget);
    expect(
      find.byWidgetPredicate(
          (widget) => _findSvgImagePredicate(widget, expectedPokemon)),
      findsOneWidget,
    );
  }

  bool _findSvgImagePredicate(Widget widget, PokemonEntity expectedPokemon) {
    final checkWidget = widget;

    if (checkWidget is SvgPicture) {
      final isNetwork = checkWidget.pictureProvider is NetworkPicture &&
          (checkWidget.pictureProvider as NetworkPicture).url ==
              expectedPokemon.svgSprite;
      return isNetwork;
    }

    return false;
  }

  Future<void> testPokemonAttributes(WidgetTester tester) async {
    repository.returnList = [
      PokemonEntity.dummy(),
    ];

    final expectedPokemon = PokemonEntity.dummy();

    await _pumpAndOpenDetailScreen(tester, expectedPokemon);

    expect(find.byType(PokemonAtrribute), findsOneWidget);
    _expectAttribute("Height", "40");
    _expectAttribute("Weight", "120");
    _expectAttribute("BMI", "10");
  }

  void _expectAttribute(String attribute, String value) {
    expect(find.text(attribute), findsOneWidget);
    expect(find.text(value), findsAtLeastNWidgets(1));
  }

  Future<void> testPokemonStats(WidgetTester tester) async {
    final expectedPokemon = PokemonEntity.dummy().copyWith(stats: const [
      PokemonStatEntity(name: "Hp", stat: 70),
      PokemonStatEntity(name: "Attack", stat: 20),
      PokemonStatEntity(name: "Defence", stat: 30),
      PokemonStatEntity(name: "Speed", stat: 78),
      PokemonStatEntity(name: "Special-attac", stat: 45),
      PokemonStatEntity(name: "Flier", stat: 105),
    ]);

    repository.returnList = [
      expectedPokemon.copyWith(),
    ];

    await _pumpAndOpenDetailScreen(tester, expectedPokemon);

    for (var stat in expectedPokemon.stats) {
      expect(find.byKey(ValueKey(stat)), findsOneWidget);
      expect(
        find.byType(Slider),
        findsAtleastOnePokemonStatSlider(stat: stat.stat),
      );
    }
  }

  Future<void> testAddToFavourite(WidgetTester tester) async {
    final expected = PokemonEntity.dummy().copyWith(id: 2);

    repository.returnList = [expected];
    repository.favouritesReturnList = [];
    
    await _pumpAndOpenDetailScreen(tester, expected);

    _expectMarkAsFavouriteButton();

    repository.favouritesReturnList = [expected.copyWith()];

    await tester.tap(find.byKey(const ValueKey("favourite-fab")));

    await tester.pumpAndSettle();

    _expectRemoveFromFavouriteButton();
  }

  Future<void> testRemoveFromFavourite(WidgetTester tester) async {
    final expected = PokemonEntity.dummy()
        .copyWith(type: "Hello", id: 602, isFavourited: false, stats: []);

    repository.returnList = [
      expected.copyWith(),
    ];

    repository.favouritesReturnList = [expected.copyWith(isFavourited: true)];

    await _pumpAndOpenDetailScreen(tester, expected);

    _expectRemoveFromFavouriteButton();

    repository.favouritesReturnList = [];

    await tester.tap(find.byKey(const ValueKey("favourite-fab")));

    await tester.pump();

    _expectMarkAsFavouriteButton();
  }

  Future<void> _pumpAndOpenDetailScreen(
      WidgetTester tester, PokemonEntity expected) async {
    await TestUtils.pumpApp(tester, repository: repository);

    await tester.tap(find.byKey(ValueKey(expected)));

    await tester.pumpAndSettle();
  }

  void _expectMarkAsFavouriteButton() {
    expect(find.text("Mark as favourite"), findsOneWidget);
    expect(find.text("Remove from favourite"), findsNothing);
  }

  void _expectRemoveFromFavouriteButton() {
    expect(find.text("Mark as favourite"), findsNothing);
    expect(find.text("Remove from favourite"), findsOneWidget);
  }
}
