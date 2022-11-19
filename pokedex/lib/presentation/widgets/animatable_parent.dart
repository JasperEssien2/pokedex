import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatableParent extends StatefulWidget {
  const AnimatableParent({
    super.key,
    required this.performAnimation,
    this.animationType = AnimationType.scale,
    this.curve,
    this.duration,
    this.delayMilliseconds,
    this.index = 0,
    required this.child,
  });

  final bool performAnimation;
  final Curve? curve;
  final Duration? duration;
  final int? delayMilliseconds;
  final int index;
  final AnimationType animationType;

  final Widget child;

  @override
  State<AnimatableParent> createState() => _AnimatableParentState();
}

class _AnimatableParentState extends State<AnimatableParent> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();

    _updateAnimation();
  }

  Future<void> _updateAnimation() async {
    if (widget.performAnimation) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        final delayDuration = Duration(
            milliseconds: widget.index == 0
                ? 0
                : (widget.delayMilliseconds ?? 60) * widget.index);

        Future.delayed(delayDuration).then(
          (value) {
            setState(() {
              _animate = !_animate;
            });
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.duration ?? const Duration(milliseconds: 400);

    final curve = widget.curve ?? Curves.linear;

    switch (widget.animationType) {
      case AnimationType.slide:
        return AnimatedSlide(
          duration: duration,
          curve: curve,
          offset: widget.performAnimation
              ? (_animate ? Offset.zero : const Offset(1, 0))
              : const Offset(1, 0),
          child: widget.child,
        );
      case AnimationType.scale:
    }
    return AnimatedScale(
      duration: duration,
      curve: curve,
      scale: widget.performAnimation
          ? _animate
              ? 1
              : 0
          : 1,
      child: widget.child,
    );
  }
}

enum AnimationType { scale, slide }
