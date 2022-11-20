import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/presentation/data_controller.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';
import 'package:pokedex/util.dart/util_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(IconUtil.appIcon),
      ),
      body: DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                color: Colors.white,
                child: const _TabBar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TabBarView(
                    children: [
                      PokemonGridView<PokemonDataController>.pokemons(
                        listenable: context
                            .dataController<FavoritePokenDataController>(),
                      ),
                      PokemonGridView<
                          FavoritePokenDataController>.favouritedPokemons(
                        emptyStateTapped: () => _moveToFirstTab(context),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void _moveToFirstTab(BuildContext context) {
    DefaultTabController.of(context)!.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    const tabs = ["All Pokemons", "Favourites"];

    return TabBar(
      tabs: [
        Tab(
          text: tabs.first,
        ),
        Tab(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(tabs.last),
              const SizedBox(width: 10),
              const FavouritedCountChip(),
            ],
          ),
        ),
      ],
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 3.0,
    );
  }
}
