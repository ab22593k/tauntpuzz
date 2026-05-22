import 'package:go_router/go_router.dart';
import 'package:lullaby/ui/core/error_screen.dart';
import 'package:lullaby/ui/features/home/home_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}
