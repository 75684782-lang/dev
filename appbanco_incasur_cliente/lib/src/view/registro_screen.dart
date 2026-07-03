import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class RegistroScreen extends ConsumerStatefulWidget {
  const RegistroScreen({super.key});

  @override
  ConsumerState<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends ConsumerState<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dniCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _negocioCtrl = TextEditingController();
  bool _registrando = false;

  @override
  void dispose() {
    _dniCtrl.dispose();
    _claveCtrl.dispose();
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _negocioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg-login.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    IncasurTheme.azulProfundo.withAlpha(230),
                    IncasurTheme.azulOscuro.withAlpha(210),
                    IncasurTheme.azulOscuro.withAlpha(200),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [IncasurTheme.amarillo, IncasurTheme.dorado],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: IncasurTheme.dorado.withAlpha(80),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.agriculture, size: 42, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [IncasurTheme.amarillo, IncasurTheme.dorado],
                        ).createShader(bounds),
                        child: const Text(
                          'CRAC Incasur',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Crear Cuenta Microempresarial',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withAlpha(200),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 36),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(210),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withAlpha(80),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(40),
                                  blurRadius: 30,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _dniCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'DNI',
                                    prefixIcon: Icon(Icons.badge_outlined),
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 8,
                                  validator: (v) => v == null || v.length != 8 ? 'DNI debe tener 8 dígitos' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _nombreCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre Completo',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _telefonoCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Teléfono',
                                    prefixIcon: Icon(Icons.phone_outlined),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (v) => v == null || v.length < 9 ? 'Teléfono inválido' : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _negocioCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre del Negocio (opcional)',
                                    prefixIcon: Icon(Icons.store_outlined),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _claveCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                  obscureText: true,
                                  validator: (v) => v == null || v.length < 4 ? 'Mínimo 4 caracteres' : null,
                                ),
                                if (_registrando)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: CircularProgressIndicator(),
                                  ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _registrando ? null : _registrar,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: IncasurTheme.azulProfundo,
                                      foregroundColor: Colors.white,
                                      elevation: 6,
                                      shadowColor: IncasurTheme.azulProfundo.withAlpha(120),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text('Crear Cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: IncasurTheme.amarillo,
                        ),
                        child: const Text(
                          '¿Ya tienes cuenta? Inicia Sesión',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _registrando = true);

    final ok = await ref.read(authProvider.notifier).registrar({
      'dni': _dniCtrl.text.trim(),
      'clave': _claveCtrl.text,
      'nombre_completo': _nombreCtrl.text.trim(),
      'telefono': _telefonoCtrl.text.trim(),
      'negocio_nombre': _negocioCtrl.text.trim(),
    });

    setState(() => _registrando = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validación biométrica simulada exitosa'), backgroundColor: Colors.green));
      context.go('/dashboard');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error en el registro'), backgroundColor: Colors.red));
    }
  }
}
