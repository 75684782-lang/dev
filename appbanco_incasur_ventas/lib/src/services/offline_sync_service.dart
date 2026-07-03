import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../model/sync_outbox_item.dart';
import 'local_persistence_service.dart';
import 'api_client.dart';

class OfflineSyncService {
  List<SyncOutboxItem> _outbox = [];
  bool _isSyncing = false;
  bool _initialized = false;

  List<SyncOutboxItem> get pendingItems => _outbox.where((e) => e.pendienteSync).toList();
  List<SyncOutboxItem> get allItems => List.unmodifiable(_outbox);
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    final saved = await LocalPersistenceService.loadOutbox();
    _outbox = saved.map((json) => SyncOutboxItem.fromJson(json)).toList();
    _initialized = true;
  }

  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  Future<void> _persist() async {
    final data = _outbox.map((item) => item.toJson()).toList();
    await LocalPersistenceService.saveOutbox(data);
  }

  void addToOutbox(String operacion, Map<String, dynamic> datos) {
    _outbox.add(SyncOutboxItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      operacion: operacion,
      datosJson: datos,
      pendienteSync: true,
      creadoEn: DateTime.now(),
    ));
    _persist();
  }

  Future<void> syncPending() async {
    if (_isSyncing) return;
    if (!(await isOnline)) return;

    _isSyncing = true;
    final pending = pendingItems;

    for (final item in pending) {
      try {
        await ApiClient.post('/sync/outbox', {
          'operacion': item.operacion,
          'datos_json': item.datosJson,
        });
        _outbox.remove(item);
      } catch (_) {}
    }

    await _persist();
    _isSyncing = false;
  }

  Future<void> autoSyncPeriodically() async {
    await initialize();
    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      await syncPending();
    }
  }
}
