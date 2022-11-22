# Reference guide to my submission

This task was quite an interesting one. As with all my projects, I started with understanding the scope and state of this app.

I decided to use the clean-architecture structure, for architecting the app. I built the app in these stages: `UI -> Domain -> Data`.

For a small-scale project like this,  I concluded that using state-management libraries might be overkill, and went with using what Flutter has provided: `ChangeNotifiers` and `InheritedWidget`.

![Demo](display/app_demo.gif)
### Structure 
The sample structure of this project is displayed below:

    integration_test/
        |- app_test.dart
        |- custom_finders_matchers.dart
        |- detail_screen_test_cases.dart
        |- home_screen_test_cases.dart
        |
    lib/
        |- data
        |  |- models
        |  |- data_sources
        |  |_repository_impl.dart
        |
        |- domain
        |  |- entity_mapper.dart
        |  |- pokemon_entity.dart
        |  |_ repository_base.dart
        |
        |- presentation
        |  |- widgets
        |  |  |_ widget_export.dart
        |  |
        |  |_ data_controllers.dart
        |  |_ data_provider.dart
        |  |_ detail_screen.dart
        |  |_ home_screen.dart
        |
        |- util
        |   |- colors.dart
        |   |- extensions.dart
        |   |- icon_util.dart
        |   |_util_export.dart
        |
        |_ main.dart

The presentation layer consists of all UI-related code, including UI logic. This layer depends on the Domain layer.

The domain layer bridge the presentation layer and the data layer. Since the presentation layer is only allowed to communicate with this layer. The base repository, entity(`PokemonEntity`), and entity mappers are defined here. The `PokemonEntity` is a simple data class that holds specific UI-related fields. It knows nothing about what the actual data coming from the server looks like. The mapper classes are provided to map a data model to an entity class.

The data layer holds all business logic. It's the backbone of any data-related task. It houses model data classes that parse JSON objects, an implementation of the repository, a data source, and a local data source.

The util folder contains some utilities used across apps, like colours, extensions, etc.

### Packages used
The dependencies used are listed below:
- [Google fonts](https://pub.dev/packages/google_fonts): This package is included to utilise *Noto Sans* font for the application.
- [Shimmer](https://pub.dev/packages/shimmer): The loading effect is handled by this package.
- [Equatable](https://pub.dev/packages/equatable): Provides easy implementation of value-based equality of different object types. 
- [Flutter SVG](https://pub.dev/packages/flutter_svg): Used to display network SVG  image URLs.
- [Either Dart](https://pub.dev/packages/either_dart):  Provides a seamless, efficient way for handling errors.
- [GraphQL](https://pub.dev/packages/graphql): Used to interact with pokemon GraphQL APIs. This also includes an internal [Hive](https://pub.dev/packages/hive) local storage implementation.
    > To understand why both graphql and dio are included in this project move down by tapping [here](#why-graphql-and-restful-implementation)
- [Path Provider](https://pub.dev/packages/path_provider): 
- [Dio](https://pub.dev/packages/dio): Used to interact with pokemon RESTful APIs. 
  > To understand why both graphql and dio are included in this project move down by tapping [here](#why-graphql-and-restful-implementation)
- [Path Provider](https://pub.dev/packages/path_provider): Used by the [Hive](https://pub.dev/packages/hive) package to get a local storage path on the device.

#### Dev dependencies
- [Integration Test](): A package to aid in running integration tests on real devices or emulators.
- [Mocktail](https://pub.dev/packages/mocktail): Used to mock certain part of the code for unit testing.

### Why Graphql and Restful implementation
Why is both `Dio` and `GraphQL` implemented in the same app? You may be wondering that. The reason is simple: I noticed pokemon has a [graphql API](beta.pokeapi.co/graphql/console) which is still in beta. Based on my experience using GraphQL and the flexibility it offers, I decided to go for it.

Everything worked out fine until I was greeted with bad news. I tried test-running my app some days after and was greeted with a *server-down error*. At that point, I recalled the wise advice of not using resources still in beta, at least for production. Despite this challenge, there was light at the end of the tunnel.

The project was structured flexibly. It allows data sources can be switched easily. After I was done with setting up the REST API, I thought it would be cool to keep both implementations.

To switch from REST APIs to GraphQL APIs, head over to `lib/main.dart` on `line 15`, and replace the code, with the code below.

```dart
final dataSource = GraphQlDataSource();
```
Now the app uses data from GraphQL API.
> To know more about the flexibility GraphQL offers, here's an article I wrote concerning this subject: [GraphQL article](https://blog.codemagic.io/flutter-graphql/).


### Testing
It can be painful sometimes to write tests. It was a bitter-sweet experience for me writing these test cases but it was worth it. However, I do believe testing is an integral part of software development. I make it an aim to write both *unit tests* and *widget tests*. Moreso, *integration tests* are even far better than unit and widget testing. 

Integration test ensures that multiple components (widget, state-holders, repository) of a complete or large part of the app work together as expected, unlike unit test and widget test that ensures individual component/piece works together.

I focused on writing integration tests for the app, that's why unit test cases are few, and no widget test cases. Integration test covers a large part. To run this integration test with coverage, use the command below.

```
flutter test integration_test/app_test.dart --coverage
```

I wrote some unit test cases to ensure `GraphQlDataSource` and `RepositoryImpl` work as expected. To run these test cases with coverage, use the command below.

```
flutter test --coverage
```

Thank you for taking the timeout to review my project. I hope this writing gives you the insight you need when looking through the codebase.
