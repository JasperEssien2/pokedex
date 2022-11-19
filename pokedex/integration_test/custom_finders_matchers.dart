import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';

findInfoWidget({required String text, required String buttonText}) =>
    _InfoWidgetFinder(text, buttonText);

class _InfoWidgetFinder extends MatchFinder {
  _InfoWidgetFinder(this.text, this.buttonText);

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

