import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';
import 'package:pokedex/util.dart/util_export.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
  });

  final PokemonEntity pokemon;

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
            flexibleSpace: _AppBar(pokemon: pokemon, textTheme: textTheme),
          ),
          SliverToBoxAdapter(
            child: _PokemonAtrribute(attribute: pokemon.attribute),
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
                    color: sliderInActiveColor,
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Mark as favourite",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
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

class _PokemonAtrribute extends StatelessWidget {
  const _PokemonAtrribute({required this.attribute});

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
