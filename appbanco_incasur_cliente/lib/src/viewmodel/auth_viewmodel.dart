import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repository.dart';

final authProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final vm = AuthViewModel();
  vm._init();
  return vm;
});

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  bool _isLoading = false;
  String? _error;
  String? _token;
  String? _rol;
  String? _usuarioId;
  bool _initialized = false;
  int _loginAttempts = 0;
  DateTime? _blockedUntil;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  String? get rol => _rol;
  String? get usuarioId => _usuarioId;
  bool get isLoggedIn => _token != null;
  bool get initialized => _initialized;
  int get loginAttempts => _loginAttempts;
  DateTime? get blockedUntil => _blockedUntil;
  bool get isBlocked => _blockedUntil != null && DateTime.now().isBefore(_blockedUntil!);
  Duration? get blockRemaining => isBlocked ? _blockedUntil!.difference(DateTime.now()) : null;

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    _loginAttempts = prefs.getInt('login_attempts') ?? 0;
    final blockUntilMs = prefs.getInt('blocked_until');
    if (blockUntilMs != null) {
      _blockedUntil = DateTime.fromMillisecondsSinceEpoch(blockUntilMs);
      if (DateTime.now().isAfter(_blockedUntil!)) {
        _blockedUntil = null;
        _loginAttempts = 0;
        await prefs.remove('blocked_until');
        await prefs.setInt('login_attempts', 0);
      }
    }

    final session = await AuthRepository.checkSession();
    if (session) {
      final data = await AuthRepository.getSession();
      _token = 'restored';
      _usuarioId = data['usuario_id'];
      _rol = data['rol'];
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> registrar(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.registro(data);
      _token = result['access_token'];
      _rol = result['rol'];
      _usuarioId = result['usuario_id'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error en el registro. Verifique los datos.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String dni, String clave) async {
    if (isBlocked) {
      _error = 'Demasiados intentos. Espere ${blockRemaining!.inMinutes} minutos.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.login(dni, clave);

      await _resetAttempts();

      _token = result['access_token'];
      _rol = result['rol'];
      _usuarioId = result['usuario_id'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loginAttempts++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('login_attempts', _loginAttempts);

      if (_loginAttempts >= 5) {
        _blockedUntil = DateTime.now().add(const Duration(minutes: 30));
        await prefs.setInt('blocked_until', _blockedUntil!.millisecondsSinceEpoch);
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
    await prefs.setInt('login_attempts', 0);
    await prefs.remove('blocked_until');
  }

  Future<void> logout() async {
    await _repository.logout();
    _token = null;
    _rol = null;
    _usuarioId = null;
    notifyListeners();
  }
}
