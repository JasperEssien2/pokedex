import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/presentation/data_controller.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';
import 'package:pokedex/util.dart/util_export.dart';

class PokemonDetailScreen extends StatefulWidget {
  static String pageName = "PokemonDetailScreen";

  const PokemonDetailScreen({
    super.key,
    this.pokemon,
  });

  final PokemonEntity? pokemon;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late final _dataController = AddToFavouriteDataController(
    favoritePokenDataController: context.favouritePokemonController,
  );
  late PokemonEntity pokemon;

  @override
  void didChangeDependencies() {
    if (widget.pokemon != null) {
      pokemon = widget.pokemon!;
    } else {
      pokemon = ModalRoute.of(context)!.settings.arguments as PokemonEntity;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: pokemon.backgroundColor,
            pinned: false,
            flexibleSpace: DetailAppBar(pokemon: pokemon, textTheme: textTheme),
          ),
          SliverToBoxAdapter(
            child: PokemonAtrribute(attribute: pokemon.attribute),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Base stats",
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: lightShadeGreyColor,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: pokemon.stats
                    .map((e) => ItemStats(
                          key: ValueKey(e),
                          stat: e,
                          index: pokemon.stats.indexOf(e),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _dataController,
        builder: (context, _) {
          return AppFloatingActionButton(
            dataController: _dataController,
            entity: pokemon,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }
}

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    Key? key,
    required this.dataController,
    required this.entity,
  }) : super(key: key);

  final AddToFavouriteDataController dataController;
  final PokemonEntity entity;

  @override
  Widget build(BuildContext context) {
    final isFavourite = dataController.isFavourited(entity);

    return FloatingActionButton.extended(
      key: const ValueKey("favourite-fab"),
      backgroundColor: isFavourite ? appLightColor : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          isFavourite ? "Remove from favourite" : "Mark as favourite",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isFavourite ? appColor : Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      onPressed: () => dataController.saveFavourite(entity),
    );
  }
}

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({
    Key? key,
    required this.pokemon,
    required this.textTheme,
  }) : super(key: key);

  final PokemonEntity pokemon;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 140),
        child: Row(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatableParent(
                index: 0,
                performAnimation: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name,
                      style: textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textBlackColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      pokemon.type,
                      style: textTheme.headlineMedium,
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    Text(
                      pokemon.id.pokemonId,
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Hero(
                  tag: pokemon.imageTag,
                  child: SvgPicture.network(
                    pokemon.svgSprite,
                    width: 130,
                    height: 125,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonAtrribute extends StatelessWidget {
  const PokemonAtrribute({super.key, required this.attribute});

  final PokemonAttributeEntity attribute;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWidget(context, "Height", attribute.height),
          _buildWidget(context, "Weight", attribute.weight),
          _buildWidget(context, "BMI", attribute.bmi),
        ],
      ),
    );
  }

  Widget _buildWidget(BuildContext context, String caption, num value) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: textStyle.bodySmall,
          ),
          const SizedBox(height: 2),
          Text("$value", style: textStyle.bodyMedium),
        ],
      ),
    );
  }
}
