import 'package:tauntpuzz/ui/features/drawer/app_drawer.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/puzzle_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: AppDrawer(),
      body: PuzzleView(),
    );
  }
}
