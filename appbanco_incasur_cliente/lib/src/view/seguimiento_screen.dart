import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../viewmodel/solicitud_viewmodel.dart';

class SeguimientoScreen extends ConsumerStatefulWidget {
  final String? expediente;
  const SeguimientoScreen({super.key, this.expediente});

  @override
  ConsumerState<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends ConsumerState<SeguimientoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final exp = widget.expediente ?? 'EXP-2026-0001';
      ref.read(solicitudProvider.notifier).cargarDetalleSolicitud(exp);
    });
  }

  @override
  Widget build(BuildContext context) {
    final solVM = ref.watch(solicitudProvider);
    final solicitud = solVM.solicitudDetalle;
    final lineaTiempo = (solicitud?['linea_tiempo'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (solVM.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Seguimiento'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
              ),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [IncasurTheme.blanco, IncasurTheme.grisClaro.withAlpha(150)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: IncasurTheme.azulProfundo.withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description_outlined, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              solicitud?['numero_expediente'] ?? 'EXP-0000',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Monto solicitado: S/ ${(solicitud?['monto_solicitado'] as num?)?.toStringAsFixed(2) ?? '0'}',
                              style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: IncasurTheme.dorado.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: IncasurTheme.dorado.withAlpha(100)),
                        ),
                        child: Text(
                          (solicitud?['estado'] as String? ?? '').replaceAll('_', ' '),
                          style: const TextStyle(color: IncasurTheme.amarillo, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [IncasurTheme.amarillo, IncasurTheme.dorado],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Línea de Tiempo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (lineaTiempo.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.timeline_outlined, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    const Text('No hay información de seguimiento disponible', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else
              ...List.generate(lineaTiempo.length, (i) {
                final item = lineaTiempo[i];
                final activo = item['activo'] == true;
                final iconStr = item['icono'] as String? ?? '📄';
                final icon = _emojiToIcon(iconStr);
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 44,
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: activo
                                    ? const LinearGradient(
                                        colors: [IncasurTheme.verdeAndino, Color(0xFF1B5E20)],
                                      )
                                    : null,
                                color: activo ? null : Colors.grey[200],
                                boxShadow: activo
                                    ? [
                                        BoxShadow(
                                          color: IncasurTheme.verdeAndino.withAlpha(80),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(icon, color: activo ? Colors.white : Colors.grey[400], size: 22),
                            ),
                            if (i < lineaTiempo.length - 1)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: activo
                                        ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              IncasurTheme.verdeAndino,
                                              Colors.grey[300]!,
                                            ],
                                          )
                                        : null,
                                    color: activo ? null : Colors.grey[200],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: activo ? IncasurTheme.verdeAndino.withAlpha(10) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: activo
                                ? Border.all(color: IncasurTheme.verdeAndino.withAlpha(50))
                                : Border.all(color: Colors.grey[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(activo ? 15 : 8),
                                blurRadius: activo ? 12 : 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['label'] as String? ?? '',
                                style: TextStyle(
                                  fontWeight: activo ? FontWeight.bold : FontWeight.normal,
                                  color: activo ? IncasurTheme.verdeAndino : IncasurTheme.azulProfundo,
                                  fontSize: 15,
                                ),
                              ),
                              if (activo) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Estado actual',
                                  style: TextStyle(
                                    color: IncasurTheme.verdeAndino.withAlpha(150),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  IconData _emojiToIcon(String emoji) {
    switch (emoji) {
      case '📩': return Icons.mail_outline;
      case '🔍': return Icons.search;
      case '✅': return Icons.check_circle_outline;
      case '💰': return Icons.account_balance_wallet;
      default: return Icons.circle;
    }
  }
}
