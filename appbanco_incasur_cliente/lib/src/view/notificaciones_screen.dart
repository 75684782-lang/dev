import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: IncasurTheme.azulProfundo,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notifCard(Icons.check_circle, 'Solicitud aprobada', 'Tu crédito EXP-2026-001 fue aprobado. Desembolso en 48h.', Colors.green, true),
          _notifCard(Icons.pending, 'Solicitud en evaluación', 'EXP-2026-003 está siendo evaluado por el comité.', IncasurTheme.dorado, false),
          _notifCard(Icons.notifications, 'Recordatorio de pago', 'Tu cuota vence en 3 días. Realiza el pago a tiempo.', IncasurTheme.azulProfundo, false),
        ],
      ),
    );
  }

  Widget _notifCard(IconData icon, String title, String body, Color color, bool leida) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: leida ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: leida ? Colors.grey[200]! : color.withAlpha(40)),
        boxShadow: leida ? null : [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: TextStyle(fontWeight: leida ? FontWeight.normal : FontWeight.bold)),
        subtitle: Text(body, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ),
    );
  }
}
