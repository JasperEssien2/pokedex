import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/presentation/widgets/widget_export.dart';

import '../../util.dart/util_export.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonText,
  });

  final String text;
  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const sizedBox = SizedBox(height: 16);

    return Align(
      alignment: const Alignment(0.5, -0.35),
      child: Container(
        margin: const EdgeInsets.all(24),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatableParent(
              performAnimation: true,
              curve: Curves.bounceOut,
              duration: const Duration(milliseconds: 900),
              child: SvgPicture.asset(
                IconUtil.icDisapointed,
                height: 90,
                width: 90,
              ),
            ),
            sizedBox,
            Text(text, style: textTheme.bodyLarge),
            sizedBox,
            if (buttonText != null)
              FloatingActionButton.extended(
                elevation: 0,
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    buttonText!,
                    style: textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ),
                onPressed: onPressed,
              ),
            sizedBox,
          ],
        ),
      ),
    );
  }
}

enum Info {
  info,
  error,
}
