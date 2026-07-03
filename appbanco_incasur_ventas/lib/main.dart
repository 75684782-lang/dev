import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/config.dart';
import 'theme.dart';
import 'src/view/router_config.dart';
import 'src/services/offline_sync_service.dart';

final offlineSyncProvider = Provider<OfflineSyncService>((ref) {
  final service = OfflineSyncService();
  service.initialize();
  service.autoSyncPeriodically();
  return service;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  runApp(const ProviderScope(child: AppVentas()));
}

class AppVentas extends ConsumerWidget {
  const AppVentas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'CRAC Incasur - Ventas',
      theme: IncasurTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
