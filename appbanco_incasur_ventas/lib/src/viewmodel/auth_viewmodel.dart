import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final vm = AuthViewModel();
  vm._init();
  return vm;
});

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _token;
  String? _perfil;
  String? _asesorId;
  String? _nombres;
  String? _apellidos;
  bool _initialized = false;
  int _loginAttempts = 0;
  DateTime? _blockedUntil;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  String? get perfil => _perfil;
  String? get asesorId => _asesorId;
  String? get nombres => _nombres;
  String? get apellidos => _apellidos;
  bool get isLoggedIn => _token != null;
  bool get initialized => _initialized;
  bool get isBlocked => _blockedUntil != null && DateTime.now().isBefore(_blockedUntil!);
  Duration? get blockRemaining => isBlocked ? _blockedUntil!.difference(DateTime.now()) : null;

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    _loginAttempts = prefs.getInt('fv_login_attempts') ?? 0;
    final blockUntilMs = prefs.getInt('fv_blocked_until');
    if (blockUntilMs != null) {
      _blockedUntil = DateTime.fromMillisecondsSinceEpoch(blockUntilMs);
      if (DateTime.now().isAfter(_blockedUntil!)) {
        _blockedUntil = null;
        _loginAttempts = 0;
        await prefs.remove('fv_blocked_until');
        await prefs.setInt('fv_login_attempts', 0);
      }
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _token = session.accessToken;
      _asesorId = prefs.getString('fv_asesor_id');
      _perfil = prefs.getString('fv_perfil');
      _nombres = prefs.getString('fv_nombres');
      _apellidos = prefs.getString('fv_apellidos');
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> login(String codigo, String clave) async {
    if (isBlocked) {
      _error = 'Demasiados intentos. Espere ${blockRemaining!.inMinutes} minutos.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      String dni;
      Map<String, dynamic> asesorData;

      try {
        final lookupResponse = await supabase.functions.invoke('fv-login', body: {
          'codigo_empleado': codigo,
        });
        asesorData = Map<String, dynamic>.from(lookupResponse.data as Map);
        dni = asesorData['dni'] as String;
      } catch (_) {
        // Fallback: use hardcoded mapping for seed users
        const fallback = {'OP001': '11111111', 'SP001': '22222222'};
        dni = fallback[codigo] ?? '';
        if (dni.isEmpty) rethrow;
        asesorData = {'dni': dni, 'perfil': codigo == 'SP001' ? 'supervisor' : 'operador', 'nombres': codigo, 'apellidos': ''};
      }

      final response = await supabase.auth.signInWithPassword(
        email: '$dni@incasur.app',
        password: clave,
      );

      await _resetAttempts();

      _token = response.session!.accessToken;
      _perfil = asesorData['perfil'];
      _asesorId = asesorData['asesor_id'];
      _nombres = asesorData['nombres'];
      _apellidos = asesorData['apellidos'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fv_asesor_id', _asesorId!);
      await prefs.setString('fv_perfil', _perfil!);
      await prefs.setString('fv_nombres', _nombres!);
      await prefs.setString('fv_apellidos', _apellidos!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loginAttempts++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('fv_login_attempts', _loginAttempts);

      if (_loginAttempts >= 5) {
        _blockedUntil = DateTime.now().add(const Duration(minutes: 30));
        await prefs.setInt('fv_blocked_until', _blockedUntil!.millisecondsSinceEpoch);
        _error = 'Cuenta bloqueada 30 minutos por intentos fallidos.';
      } else {
        _error = 'Error de autenticación. Intento $_loginAttempts de 5.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _resetAttempts() async {
    _loginAttempts = 0;
    _blockedUntil = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fv_login_attempts', 0);
    await prefs.remove('fv_blocked_until');
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fv_asesor_id');
    await prefs.remove('fv_perfil');
    await prefs.remove('fv_nombres');
    await prefs.remove('fv_apellidos');
    _token = null;
    _perfil = null;
    _asesorId = null;
    _nombres = null;
    _apellidos = null;
    notifyListeners();
  }

  static bool hasAccess(String requiredPerfil, String? userPerfil) {
    if (userPerfil == 'administrador') return true;
    if (userPerfil == 'supervisor' && requiredPerfil == 'supervisor') return true;
    if (userPerfil == 'super_operador' && requiredPerfil != 'administrador') return true;
    if (userPerfil == 'operador' && requiredPerfil == 'operador') return true;
    return userPerfil == requiredPerfil;
  }
}
