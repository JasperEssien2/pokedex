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
              margin: const EdgeInsets.only(top: 2),
              color: Colors.white,
              child: TabBar(
                tabs: [
                  Tab(
                    text: _tabs.first,
                  ),
                  Tab(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_tabs.last),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Text(
                            "2",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
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

    bool isError = false;

    if (isError) {
      return const InfoWidget(text: "An error occurred", buttonText: "Retry");
    }

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
              pokemon: PokemonEntity.dummy()
                  .copyWith(id: index, isFavourited: isFavourite),
              animate: true,
            ),
    );
  }
}
