import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';
import 'package:pokedex/util.dart/colors.dart';

findInfoWidget({required String text, required String buttonText}) =>
    _InfoWidgetFinderMatcher(text, buttonText);

class _InfoWidgetFinderMatcher extends MatchFinder {
  _InfoWidgetFinderMatcher(this.text, this.buttonText);

  final String text;
  final String buttonText;

  @override
  String get description => "InfoWidget: $InfoWidget";

  @override
  bool matches(Element candidate) {
    if (candidate.widget is InfoWidget) {
      final widget = candidate.widget as InfoWidget;

      return widget.buttonText == buttonText && widget.text == text;
    }

    return false;
  }
}

findsAtleastOnePokemonStatSlider({required num stat}) =>
    _PokemonStatsSliderMatcher(stat);

class _PokemonStatsSliderMatcher extends Matcher {
  _PokemonStatsSliderMatcher(this.stat);

  final num stat;

  @override
  Description describe(Description description) {
    description.add("Match pokemon stats slider with stat $stat");
    return description;
  }

  @override
  bool matches(covariant Finder finder, Map matchState) {
    int count = 0;

    final elements = finder.evaluate().toList();

    for (var element in elements) {
      final checkFlags = <bool>[];

      if (element.widget is Slider) {
        checkFlags.add(true);
      }

      final widget = element.widget as Slider;

      checkFlags.add(widget.inactiveColor == lightShadeGreyColor);

      if (stat <= 30) {
        checkFlags.add(widget.activeColor == Colors.red.shade500);
      } else if (stat <= 70) {
        checkFlags.add(widget.activeColor == Colors.amber.shade500);
      } else {
        checkFlags.add(widget.activeColor == Colors.green.shade500);
      }

      if (stat > 100) {
        checkFlags.add(widget.max == stat.toDouble());
      } else {
        checkFlags.add(widget.max == 100.0);
      }

      checkFlags.add(widget.min == 0);

      if (checkFlags.where((element) => element == false).isEmpty) {
        count++;
      }
    }
    return count > 0;
  }
}
