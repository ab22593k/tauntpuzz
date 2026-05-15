import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:flutter/material.dart';

class DrawerButton extends StatefulWidget {
  const DrawerButton({super.key});

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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (c, _) => Transform.scale(
        scale: _pulseAnim.value,
        child: ElevatedButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            minimumSize: const Size(48, 42),
            fixedSize: const Size.fromHeight(42),
            backgroundColor: AppColors.glassSurface,
            foregroundColor: AppColors.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(
                width: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
          ).copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              return 0;
            }),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.onSurface.withValues(alpha: 0.06);
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.onSurface.withValues(alpha: 0.12);
              }
              return null;
            }),
          ),
          child: const Icon(Icons.menu, size: 22),
        ),
      ),
    );
  }
}
