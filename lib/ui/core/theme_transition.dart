import 'package:leafz/ui/core/animations/animations_manager.dart';
import 'package:flutter/material.dart';

class ThemeTransitionBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeData theme) builder;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final Duration duration;

  const ThemeTransitionBuilder({
    super.key,
    required this.builder,
    required this.lightTheme,
    required this.darkTheme,
    required this.themeMode,
    this.duration = AnimationsManager.themeTransition,
  });

  @override
  State<ThemeTransitionBuilder> createState() => _ThemeTransitionBuilderState();
}

class _ThemeTransitionBuilderState extends State<ThemeTransitionBuilder>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late CurvedAnimation _animation;
  Brightness _platformBrightness = Brightness.light;
  Brightness _currentBrightness = Brightness.light;
  Brightness? _previousBrightness;

  Brightness get _effectiveBrightness => switch (widget.themeMode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system => _platformBrightness,
  };

  @override
  void initState() {
    super.initState();
    _platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _currentBrightness = _effectiveBrightness;
    _previousBrightness = _currentBrightness;

    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addListener(_onTick);
  }

  void _onTick() {
    setState(() {});
  }

  @override
  void didChangePlatformBrightness() {
    final newPlatformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (newPlatformBrightness != _platformBrightness) {
      _platformBrightness = newPlatformBrightness;
      if (widget.themeMode == ThemeMode.system) {
        _checkAndStartAnimation();
      }
      setState(() {});
    }
  }

  void _checkAndStartAnimation() {
    final newBrightness = _effectiveBrightness;
    if (newBrightness != _currentBrightness) {
      _previousBrightness = _currentBrightness;
      _currentBrightness = newBrightness;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(ThemeTransitionBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkAndStartAnimation();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _animation.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _animation.value;

    final fromBrightness = _previousBrightness ?? _currentBrightness;
    final fromTheme = fromBrightness == Brightness.dark
        ? widget.darkTheme
        : widget.lightTheme;
    final toTheme = _currentBrightness == Brightness.dark
        ? widget.darkTheme
        : widget.lightTheme;

    final animatedTheme = ThemeData.lerp(fromTheme, toTheme, t);
    return widget.builder(context, animatedTheme);
  }
}
