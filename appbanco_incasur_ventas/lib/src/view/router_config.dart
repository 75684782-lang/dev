import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'login_screen.dart';
import 'cartera_screen.dart';
import 'ficha_cliente_screen.dart';
import 'stepper_screen.dart';
import '../model/cliente_cartera.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.read(authProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: auth,
    redirect: (context, state) {
      if (!auth.initialized) return null;
      final isLoggedIn = auth.isLoggedIn;
      final isLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLogin) return '/login';
      if (isLoggedIn && isLogin) return '/cartera';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/cartera', builder: (_, __) => const CarteraScreen()),
      GoRoute(
        path: '/ficha',
        builder: (_, state) => FichaClienteScreen(cliente: state.extra as ClienteCartera),
      ),
      GoRoute(
        path: '/solicitud',
        builder: (_, state) => StepperScreen(cliente: state.extra as ClienteCartera?),
      ),
    ],
  );
});
