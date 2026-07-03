import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'login_screen.dart';
import 'registro_screen.dart';
import 'dashboard_screen.dart';
import 'solicitud_screen.dart';
import 'cronograma_screen.dart';
import 'simulador_educativo_screen.dart';
import 'seguimiento_screen.dart';
import 'perfil_screen.dart';
import 'movimientos_screen.dart';
import 'notificaciones_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.read(authProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: auth,
    redirect: (context, state) {
      if (!auth.initialized) return null;
      final isLoggedIn = auth.isLoggedIn;
      final publicRoutes = ['/login', '/registro'];
      final isPublic = publicRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && isPublic) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/registro', builder: (_, __) => const RegistroScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/solicitud', builder: (_, __) => const SolicitudScreen()),
      GoRoute(path: '/cronograma', builder: (_, __) => const CronogramaScreen()),
      GoRoute(path: '/simulador', builder: (_, __) => const SimuladorEducativoScreen()),
      GoRoute(
        path: '/seguimiento',
        builder: (_, state) => SeguimientoScreen(expediente: state.extra as String?),
      ),
      GoRoute(path: '/perfil', builder: (_, __) => const PerfilScreen()),
      GoRoute(path: '/movimientos', builder: (_, __) => const MovimientosScreen()),
      GoRoute(path: '/notificaciones', builder: (_, __) => const NotificacionesScreen()),
    ],
  );
});
