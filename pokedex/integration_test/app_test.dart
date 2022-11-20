import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/data/fake_repository.dart';

import 'home_screen_test_cases.dart';

void main() {
  late FakeRepository repository;
  late HomeScreenTestCases homeScreenTestCases;

  setUp(
    () {
      repository = FakeRepository();
      homeScreenTestCases = HomeScreenTestCases(repository);
    },
  );

  group(
    "Test HomeScreen",
    () {
      testWidgets(
        "Ensure tabview navigates properly",
        (tester) async {
          await homeScreenTestCases.testCurrentTab(tester);
        },
      );

      group(
        "Test All Pokemons",
        () {
          testWidgets(
            "Ensure loading state behaves correcly",
            (tester) async {
              await homeScreenTestCases.testAllPokemonLoadingState(tester);
            },
          );

          testWidgets(
            "Ensure bottom loading state behaves correcly",
            (tester) async {
              await homeScreenTestCases
                  .testAllPokemonBottomLoadingState(tester);
            },
          );

          testWidgets(
            "Ensure empty state behaves correcly",
            (tester) async {
              await homeScreenTestCases.testAllPokemonEmptyState(tester);
            },
          );

          testWidgets(
            "Ensure subsequent empty state behaves correcly",
            (tester) async {
              await homeScreenTestCases
                  .testAllPokemonSubsequentEmptyState(tester);
            },
          );

          testWidgets(
            "Ensure success state behaves correcly",
            (tester) async {
              await homeScreenTestCases.testAllPokemonSuccessState(tester);
            },
          );

          testWidgets(
            "Ensure error state behaves correcly",
            (tester) async {
              await homeScreenTestCases.testAllPokemonErrorState(tester);
            },
          );

          testWidgets(
            "Ensure pagination behaves correcly",
            skip: true,
            (tester) async {
              await homeScreenTestCases.testPagination(tester);
            },
          );
        },
      );

      group(
        "Test Favourite Pokemons",
        () {
          testWidgets(
            "Ensure loading state behaves correcly",
            (tester) async {
              await homeScreenTestCases
                  .testFavouritePokemonLoadingState(tester);
            },
          );

          testWidgets(
            "Ensure empty state behaves correcly",
            (tester) async {
              await homeScreenTestCases.testFavouritePokemonEmptyState(tester);
            },
          );

          testWidgets(
            "Ensure success state behaves correcly",
            (tester) async {
              await homeScreenTestCases
                  .testFavouritePokemonSuccessState(tester);
            },
          );

          testWidgets(
            "Ensure error state behaves correctly",
            (tester) async {
              await homeScreenTestCases.testFavouritePokemonErrorState(tester);
            },
          );
        },
      );
    },
  );
}
