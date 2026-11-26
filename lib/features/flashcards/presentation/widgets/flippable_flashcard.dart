import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:idiomer/core/constants/app_durations.dart';

class FlippableFlashcard extends StatefulWidget {
  final Object cardId;
  final bool isFlipped;
  final VoidCallback onTap;
  final Widget front;
  final Widget back;

  const FlippableFlashcard({
    super.key,
    required this.cardId,
    required this.isFlipped,
    required this.onTap,
    required this.front,
    required this.back,
  });

  @override
  State<FlippableFlashcard> createState() => _FlippableFlashcardState();
}

class _FlippableFlashcardState extends State<FlippableFlashcard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
      value: widget.isFlipped ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(FlippableFlashcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cardId != widget.cardId) {
      _controller.value = widget.isFlipped ? 1.0 : 0.0;
    } else if (oldWidget.isFlipped != widget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final value = _animation.value;
          final angle = value * math.pi;
          final showBack = value >= 0.5;
          final rotationAngle = showBack ? angle - math.pi : angle;
          // Pull the card back slightly mid-flip so 3D perspective edges stay
          // comfortably within bounds without vertical clipping.
          final scale = 1.0 - 0.1 * math.sin(angle);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0008)
              ..rotateY(rotationAngle)
              ..scaleByDouble(scale, scale, 1.0, 1.0),
            child: SizedBox.expand(
              child: showBack ? widget.back : widget.front,
            ),
          );
        },
      ),
    );
  }
}
