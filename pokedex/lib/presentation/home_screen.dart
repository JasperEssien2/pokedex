import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';
import 'package:pokedex/util.dart/icon_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tabs = ["All Pokemons", "Favourites"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(IconUtil.appIcon),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                tabs: _tabs
                    .map((e) => Tab(
                          text: e,
                        ))
                    .toList(),
                indicator: const BoxDecoration(),
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: TabBarView(
                  children: [
                    PokemonGridView(),
                    PokemonGridView(isFavourite: true),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PokemonGridView extends StatelessWidget {
  const PokemonGridView({
    super.key,
    this.isFavourite = false,
  });

  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    const margin = 10.0;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: margin,
        crossAxisSpacing: margin,
        mainAxisExtent: 200,
      ),
      itemCount: 29,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => isLoading
          ? PokedexCardShimmer(index: index, animate: true)
          : PokedexCard(
              index: index,
              pokemonEntity: PokemonEntity.dummy(),
              animate: true,
            ),
    );
  }
}
