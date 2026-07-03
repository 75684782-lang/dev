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
  final _dniController = TextEditingController();
  final _claveController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _dniController.dispose();
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
          image: DecorationImage(
            image: AssetImage('assets/bg-login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                IncasurTheme.azulProfundo.withAlpha(220),
                IncasurTheme.azulOscuro.withAlpha(200),
                Colors.black.withAlpha(180),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
                    const SizedBox(height: 8),
                    Container(
                      width: 48,
                      height: 3,
                      decoration: BoxDecoration(
                        color: IncasurTheme.amarillo,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'App Cliente',
                      style: TextStyle(
                        color: Colors.white.withAlpha(180),
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _dniController,
                      decoration: InputDecoration(
                        labelText: 'DNI',
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
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      validator: (v) => v == null || v.length != 8 ? 'Ingrese DNI válido (8 dígitos)' : null,
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
                              _dniController.text.trim(),
                              _claveController.text,
                            );
                            if (ok && mounted) {
                              context.go('/dashboard');
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
                            : const Text('Iniciar Sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.push('/registro'),
                      child: Text(
                        'Crear Cuenta — Regístrate aquí',
                        style: TextStyle(
                          color: IncasurTheme.amarillo.withAlpha(200),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
      ),
    );
  }
}