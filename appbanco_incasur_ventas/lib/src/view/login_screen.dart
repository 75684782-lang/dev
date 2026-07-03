import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _codigoController = TextEditingController();
  final _claveController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codigoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              IncasurTheme.azulProfundo,
              IncasurTheme.azulOscuro,
              Color(0xFF062F3E),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: IncasurTheme.amarillo.withAlpha(60),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CRAC Incasur',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Portal Oficial de Crédito',
                    style: TextStyle(color: IncasurTheme.amarillo.withAlpha(200), fontSize: 14, letterSpacing: 2),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _codigoController,
                    decoration: InputDecoration(
                      labelText: 'Código de Empleado',
                      labelStyle: TextStyle(color: Colors.white.withAlpha(180)),
                      prefixIcon: Icon(Icons.badge, color: IncasurTheme.amarillo),
                      filled: true,
                      fillColor: Colors.white.withAlpha(25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: IncasurTheme.amarillo, width: 2),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    validator: (v) => v == null || v.isEmpty ? 'Ingrese su código' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _claveController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.white.withAlpha(180)),
                      prefixIcon: Icon(Icons.lock, color: IncasurTheme.amarillo),
                      filled: true,
                      fillColor: Colors.white.withAlpha(25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: IncasurTheme.amarillo, width: 2),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (v) => v == null || v.isEmpty ? 'Ingrese su contraseña' : null,
                  ),
                  if (authVM.error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withAlpha(80)),
                      ),
                      child: Text(
                        authVM.error!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  if (authVM.isBlocked) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Bloqueado: ${authVM.blockRemaining!.inMinutes}:${(authVM.blockRemaining!.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.orangeAccent, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authVM.isBlocked || authVM.isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          final ok = await authVM.login(
                            _codigoController.text.trim(),
                            _claveController.text,
                          );
                          if (ok && mounted) {
                            context.go('/cartera');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IncasurTheme.amarillo,
                        foregroundColor: IncasurTheme.azulProfundo,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 8,
                        shadowColor: IncasurTheme.amarillo.withAlpha(100),
                      ),
                      child: authVM.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: IncasurTheme.azulProfundo, strokeWidth: 2),
                            )
                          : const Text('Ingresar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '© 2026 CRAC Incasur — Todos los derechos reservados',
                    style: TextStyle(color: Colors.white.withAlpha(80), fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
