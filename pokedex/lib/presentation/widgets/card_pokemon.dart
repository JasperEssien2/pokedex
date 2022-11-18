// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:shimmer/shimmer.dart';

class PokedexCard extends StatelessWidget {
  const PokedexCard({
    super.key,
    required this.pokemonEntity,
  });

  final PokemonEntity pokemonEntity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _ImageContainer(
          backgroundColor: pokemonEntity.backgroundColor,
          child: SvgPicture.network(
            pokemonEntity.svgSprite,
            height: 60,
            width: 60,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text("#${pokemonEntity.id}", style: textTheme.bodySmall),
              Text("#${pokemonEntity.id}", style: textTheme.bodyMedium),
              const SizedBox(height: 10),
              Text("#${pokemonEntity.id}", style: textTheme.bodySmall),
            ],
          ),
        )
      ],
    );
  }
}

class PokedexCardShimmer extends StatelessWidget {
  const PokedexCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          const _ImageContainer(backgroundColor: Colors.white),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: const [
                _ShimmerPlaceholderCard(height: 12),
                _ShimmerPlaceholderCard(height: 14),
                SizedBox(height: 10),
                _ShimmerPlaceholderCard(height: 12),
              ],
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
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(-5, 5),
          )
        ],
      ),
      child: child,
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
