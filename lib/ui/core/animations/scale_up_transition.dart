import 'package:leafy/ui/core/animations/animations_manager.dart';
import 'package:flutter/material.dart';

class ScaleUpTransition extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final Duration? duration;
  final Curve? curve;

  const ScaleUpTransition({
    super.key,
    required this.child,
    this.delay,
    this.duration,
    this.curve,
  });

  @override
  _ScaleUpTransitionState createState() => _ScaleUpTransitionState();
}

class _ScaleUpTransitionState extends State<ScaleUpTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scale;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? AnimationsManager.scaleUp.duration,
    );

    _scale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve ?? AnimationsManager.scaleUp.curve,
      ),
    );

    if (widget.delay case final delay?) {
      Future.delayed(delay, () {
        _animationController.forward();
      });
    } else {
      _animationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
