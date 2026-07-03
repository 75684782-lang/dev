import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _negocioCtrl = TextEditingController();
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _negocioCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final userId = ref.read(authProvider).usuarioId;
    if (userId == null) return;
    final ficha = await Supabase.instance.client
        .from('clientes_ficha')
        .select('nombre_completo, telefono, negocio_nombre')
        .eq('usuario_id', userId!)
        .maybeSingle();
    if (mounted) {
      _nombreCtrl.text = ficha?['nombre_completo'] ?? '';
      _telefonoCtrl.text = ficha?['telefono'] ?? '';
      _negocioCtrl.text = ficha?['negocio_nombre'] ?? '';
    }
    if (mounted) setState(() => _cargando = false);
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    try {
      final userId = ref.read(authProvider).usuarioId;
      await Supabase.instance.client
          .from('clientes_ficha')
          .update({
            'nombre_completo': _nombreCtrl.text,
            'telefono': _telefonoCtrl.text,
            'negocio_nombre': _negocioCtrl.text,
          })
          .eq('usuario_id', userId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Datos actualizados'), backgroundColor: Colors.green.shade700),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red.shade700),
        );
      }
    }
    if (mounted) setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: IncasurTheme.azulProfundo,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _guardando || _cargando ? null : _guardar,
            child: _guardando
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Guardar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: IncasurTheme.azulProfundo.withAlpha(30),
                        child: const Icon(Icons.person, size: 48, color: IncasurTheme.azulProfundo),
                      ),
                      const SizedBox(height: 12),
                      Text(_nombreCtrl.text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildField('Nombre Completo', _nombreCtrl, Icons.person_outline),
                _buildField('Teléfono', _telefonoCtrl, Icons.phone_outlined, keyboardType: TextInputType.phone),
                _buildField('Nombre del Negocio', _negocioCtrl, Icons.store_outlined),
              ],
            ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
      ),
    );
  }
}
