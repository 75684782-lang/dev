import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../model/cliente_cartera.dart';
import '../services/api_client.dart';
import 'cartera_screen.dart';

class FichaClienteScreen extends ConsumerWidget {
  final ClienteCartera cliente;
  const FichaClienteScreen({super.key, required this.cliente});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cliente.nombre),
        backgroundColor: IncasurTheme.azulProfundo,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _seccionInfo(context),
          const SizedBox(height: 16),
          _seccionNegocio(context),
          const SizedBox(height: 24),
          _botonera(context, ref),
        ],
      ),
    );
  }

  Widget _seccionInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: IncasurTheme.azulProfundo.withAlpha(30),
                child: Text(
                  cliente.nombre.isNotEmpty ? cliente.nombre[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cliente.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo)),
                    if (cliente.telefono.isNotEmpty) Text(cliente.telefono, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withAlpha(80)),
                ),
                child: const Text('Normal', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Divider(height: 24),
          _infoRow('Teléfono', cliente.telefono.isNotEmpty ? cliente.telefono : 'No registrado'),
          _infoRow('Negocio', cliente.negocio.isNotEmpty ? cliente.negocio : 'No registrado'),
          _infoRow('Gestión', cliente.tipoGestion.replaceAll('_', ' ')),
        ],
      ),
    );
  }

  Widget _seccionNegocio(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historial Crediticio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo)),
          const SizedBox(height: 12),
          _infoRow('Deuda Total', 'S/ 5,000.00'),
          _infoRow('Cuotas al Día', '3 de 12'),
          _infoRow('Estado', 'Al día'),
        ],
      ),
    );
  }

  Widget _botonera(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/solicitud', extra: cliente),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Nueva Solicitud'),
            style: ElevatedButton.styleFrom(
              backgroundColor: IncasurTheme.verdeAndino,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map),
            label: const Text('Ver en mapa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: IncasurTheme.azulProfundo,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: const BorderSide(color: IncasurTheme.azulProfundo),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(carteraProvider.notifier).marcarVisitado(cliente.id);
              context.pop();
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Marcar como visitado'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: const BorderSide(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}
