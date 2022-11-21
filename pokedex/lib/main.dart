import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/data/data_sources/data_sources_export.dart';
import 'package:pokedex/data/data_sources/restful_api_data_source.dart';
import 'package:pokedex/data/repository_impl.dart';
import 'package:pokedex/domain/repository_base.dart';
import 'package:pokedex/presentation/data_controller.dart';
import 'package:pokedex/presentation/data_provider.dart';
import 'package:pokedex/presentation/home_screen.dart';
import 'package:pokedex/util.dart/colors.dart';

import 'presentation/detail_screen.dart';

void main() {
  final dataSource = RestfulApiDataSource();
  final repository = RepositoryImpl(dataSource: dataSource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.repository,
    this.navigatorObserver,
  });

  final RepositoryBase repository;
  final NavigatorObserver? navigatorObserver;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _favouriteController =
      FavoritePokenDataController(repository: widget.repository);
  late final _pokemonController =
      PokemonDataController(repository: widget.repository);

  @override
  void initState() {
    _favouriteController.fetch();
    _pokemonController.fetch();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        if (widget.navigatorObserver != null) widget.navigatorObserver!
      ],
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: createMaterialColor(const Color(0xff3558CD)),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          labelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.w500),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 4,
          thumbShape: SliderComponentShape.noThumb,
          overlayShape: SliderComponentShape.noThumb,
        ),
        scaffoldBackgroundColor: scaffoldColor,
        textTheme: GoogleFonts.notoSansAdlamTextTheme(),
      ),
      home: DataControllerProvider(
        dataController: _favouriteController,
        child: DataControllerProvider(
          dataController: _pokemonController,
          child: Builder(builder: (context) {
            return const HomeScreen();
          }),
        ),
      ),
      routes: {
        PokemonDetailScreen.pageName: (context) {
          return DataControllerProvider(
            dataController: _favouriteController,
            child: DataControllerProvider(
              dataController: _pokemonController,
              child: Builder(builder: (context) {
                return const PokemonDetailScreen();
              }),
            ),
          );
        },
      },
    );
  }

  //GOtten from stack overflow
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  void dispose() {
    _favouriteController.dispose();
    _pokemonController.dispose();
    super.dispose();
  }
}
