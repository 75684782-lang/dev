import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../viewmodel/solicitud_viewmodel.dart';

class SolicitudScreen extends ConsumerStatefulWidget {
  const SolicitudScreen({super.key});

  @override
  ConsumerState<SolicitudScreen> createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends ConsumerState<SolicitudScreen> {
  final _montoController = TextEditingController();
  final _plazoController = TextEditingController();
  final _destinoController = TextEditingController();
  final _garantiaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _conDesgravamen = true;
  String? _expedienteGenerado;
  bool _enviando = false;

  @override
  void dispose() {
    _montoController.dispose();
    _plazoController.dispose();
    _destinoController.dispose();
    _garantiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Solicitud'),
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
            colors: [
              IncasurTheme.blanco,
              IncasurTheme.grisClaro.withAlpha(150),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _expedienteGenerado != null
              ? _buildExito()
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
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
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.assignment_outlined, color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Datos del Crédito',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: IncasurTheme.azulProfundo,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _montoController,
                              decoration: const InputDecoration(
                                labelText: 'Monto Solicitado (S/)',
                                prefixIcon: Icon(Icons.monetization_on_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || double.tryParse(v) == null ? 'Ingrese un monto válido' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _plazoController,
                              decoration: const InputDecoration(
                                labelText: 'Plazo (meses)',
                                prefixIcon: Icon(Icons.timer_outlined),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || int.tryParse(v) == null ? 'Ingrese plazo válido' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _destinoController,
                              decoration: const InputDecoration(
                                labelText: 'Destino del Crédito',
                                prefixIcon: Icon(Icons.shopping_cart_outlined),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _garantiaController,
                              decoration: const InputDecoration(
                                labelText: 'Garantía',
                                prefixIcon: Icon(Icons.shield_outlined),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: IncasurTheme.verdeAndino.withAlpha(10),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: IncasurTheme.verdeAndino.withAlpha(40)),
                              ),
                              child: SwitchListTile(
                                title: const Text(
                                  'Seguro de Desgravamen',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: const Text(
                                  'TEA 40.92% (con seguro) / 43.92% (sin seguro)',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: _conDesgravamen,
                                activeColor: IncasurTheme.verdeAndino,
                                activeTrackColor: IncasurTheme.verdeAndino.withAlpha(100),
                                onChanged: (v) => setState(() => _conDesgravamen = v),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _enviando ? null : _enviarSolicitud,
                          style: ElevatedButton.styleFrom(
                            elevation: 6,
                            shadowColor: IncasurTheme.azulProfundo.withAlpha(120),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _enviando
                              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                              : const Text('Enviar Solicitud', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildExito() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 30, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [IncasurTheme.verdeAndino, const Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: IncasurTheme.verdeAndino.withAlpha(80),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.check_circle, size: 52, color: Colors.white),
          ),
          const SizedBox(height: 24),
          const Text(
            '¡Solicitud Enviada!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo),
          ),
          const SizedBox(height: 12),
          Text(
            'Expediente: $_expedienteGenerado',
            style: const TextStyle(fontSize: 16, color: IncasurTheme.azulProfundo, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Su solicitud ha sido registrada exitosamente',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                elevation: 6,
                shadowColor: IncasurTheme.azulProfundo.withAlpha(120),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Volver al Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enviarSolicitud() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    final data = {
      'monto_solicitado': double.parse(_montoController.text),
      'plazo_meses': int.parse(_plazoController.text),
      'con_desgravamen': _conDesgravamen,
      'garantia': _garantiaController.text,
      'destino_credito': _destinoController.text,
    };

    try {
      final vm = ref.read(solicitudProvider);
      final expediente = await vm.enviarSolicitud(data);
      setState(() {
        _expedienteGenerado = expediente;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _enviando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 6),
          action: SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
        ),
      );
    }
  }
}
