import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokedex/domain/pokemon_entity.dart';
import 'package:pokedex/util.dart/colors.dart';

import 'animatable_parent.dart';

class ItemStats extends StatelessWidget {
  const ItemStats({
    super.key,
    required this.stat,
    required this.index,
  });

  final PokemonStatEntity stat;
  final int index;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return AnimatableParent(
      performAnimation: true,
      animationType: AnimationType.slide,
      index: index,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: stat.name,
                style: textStyle.bodyMedium!
                    .copyWith(color: const Color(0xff6B6B6B)),
                children: [
                  TextSpan(
                    text: "  ${stat.stat}",
                    style: textStyle.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            IgnorePointer(
              ignoring: true,
              child: Slider(
                max: max(100, stat.stat.toDouble()),
                min: 0,
                activeColor: getColor,
                inactiveColor: lightShadeGreyColor,
                value: stat.stat.toDouble(),
                onChanged: (_) {},
              ),
            )
          ],
        ),
      ),
    );
  }

  Color get getColor {
    if (stat.stat <= 30) {
      return Colors.red.shade500;
    } else if (stat.stat <= 70) {
      return Colors.amber.shade500;
    }
    return Colors.green.shade500;
  }
}
