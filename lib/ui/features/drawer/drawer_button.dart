import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jigsaw/ui/core/layout/panes.dart';
import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:jigsaw/ui/features/drawer/app_drawer.dart';

class DrawerButton extends StatefulWidget {
  const DrawerButton({super.key});

  static const _key = ValueKey('drawer_button');

  @override
  State<DrawerButton> createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Adaptive surfacing (MD3 "levitate" strategy):
  /// On compact/medium the settings open as a navigation drawer (the
  /// docked pane slides in from the leading edge). On expanded+ where the
  /// drawer is hidden, the same content levitates into a floating pane —
  /// same destination, different presentation per breakpoint.
  void _openSettings(BuildContext context) {
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final isExpandedPlus =
        wc == WindowClass.expanded ||
        wc == WindowClass.large ||
        wc == WindowClass.extraLarge;

    if (isExpandedPlus) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => const FloatingPane(
          showScrim: true,
          modal: true,
          width: 480,
          child: AppDrawer(),
        ),
      );
    } else {
      Scaffold.of(context).openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (c, _) => Transform.scale(
        scale: _pulseAnim.value,
        child: Tooltip(
          message: 'Menu',
          preferBelow: false,
          child: ElevatedButton(
            key: DrawerButton._key,
            onPressed: () => _openSettings(context),
            style:
                ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                  minimumSize: const Size(48, 42),
                  fixedSize: const Size.fromHeight(42),
                  backgroundColor: colorScheme.surfaceContainer.withValues(
                    alpha: 0.7,
                  ),
                  foregroundColor: colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(
                      width: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.15),
                    ),
                  ),
                ).copyWith(
                  elevation: WidgetStateProperty.resolveWith((states) {
                    return 0;
                  }),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return colorScheme.onSurface.withValues(alpha: 0.06);
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return colorScheme.onSurface.withValues(alpha: 0.12);
                    }
                    return null;
                  }),
                ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedMenu01,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
