// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/presentation/detail_screen.dart';
import 'package:pokedex/presentation/widgets/shimmer_widget.dart';
import 'package:pokedex/util.dart/util_export.dart';

import 'animatable_parent.dart';

class PokedexCard extends StatelessWidget {
  const PokedexCard({
    required this.pokemon,
    required this.index,
    this.animate = false,
  }) : super(key: null);

  final PokemonEntity pokemon;
  final int index;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatableParent(
      index: index,
      delayMilliseconds: 30,
      performAnimation: animate,
      child: GestureDetector(
        key: ValueKey(pokemon),
        onTap: () {
          Navigator.pushNamed(
            context,
            PokemonDetailScreen.pageName,
            arguments: pokemon,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ImageContainer(
              backgroundColor: pokemon.backgroundColor,
              child: Hero(
                tag: pokemon.imageTag,
                child: SvgPicture.network(
                  pokemon.svgSprite,
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pokemon.id.pokemonId, style: textTheme.bodySmall),
                  Text(
                    pokemon.name,
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pokemon.type,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PokedexCardShimmer extends StatelessWidget {
  const PokedexCardShimmer({
    super.key,
    required this.index,
    required this.animate,
  });

  final int index;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return AnimatableParent(
      index: index,
      performAnimation: animate,
      child: Column(
        children: [
          _ImageContainer(
            backgroundColor: Colors.white,
            child: ShimmerWidget(
              child: Container(
                height: 70,
                width: 70,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ShimmerWidget(
              child: Column(
                children: const [
                  _ShimmerPlaceholderCard(height: 12),
                  SizedBox(height: 2),
                  _ShimmerPlaceholderCard(height: 14),
                  SizedBox(height: 10),
                  _ShimmerPlaceholderCard(height: 12),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  const _ImageContainer({
    required this.backgroundColor,
    this.child,
  });

  final Color backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: 105,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(-5, 5),
          )
        ],
      ),
      child: Center(child: child),
    );
  }
}

class _ShimmerPlaceholderCard extends StatelessWidget {
  const _ShimmerPlaceholderCard({super.key, this.height, this.width});
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 14,
      width: width ?? double.infinity,
      color: Colors.white,
    );
  }
}
