import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';

class MovimientosScreen extends StatelessWidget {
  const MovimientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movimientos = [
      {'fecha': '15 Jun 2026', 'desc': 'Pago de cuota - EXP-2026-001', 'monto': -450.00},
      {'fecha': '10 Jun 2026', 'desc': 'Desembolso - EXP-2026-001', 'monto': 5000.00},
      {'fecha': '01 Jun 2026', 'desc': 'Comisión por desgravamen', 'monto': -15.50},
      {'fecha': '20 May 2026', 'desc': 'Pago de cuota - EXP-2026-002', 'monto': -320.00},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
        backgroundColor: IncasurTheme.azulProfundo,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movimientos.length,
        itemBuilder: (_, i) {
          final m = movimientos[i];
          final isIngreso = (m['monto'] as double) > 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: ListTile(
              leading: Icon(isIngreso ? Icons.arrow_downward : Icons.arrow_upward, color: isIngreso ? Colors.green : Colors.red),
              title: Text(m['desc'] as String, style: const TextStyle(fontSize: 14)),
              subtitle: Text(m['fecha'] as String, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              trailing: Text(
                '${isIngreso ? '+' : ''}S/ ${(m['monto'] as double).abs().toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, color: isIngreso ? Colors.green : Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
