import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/solicitud_repository.dart';
import '../model/solicitud.dart';
import 'auth_viewmodel.dart';

final solicitudProvider = ChangeNotifierProvider<SolicitudViewModel>((ref) {
  return SolicitudViewModel(ref);
});

class SolicitudViewModel extends ChangeNotifier {
  final Ref _ref;
  late final SolicitudRepository _repository;

  SolicitudViewModel(this._ref) {
    _repository = SolicitudRepository();
  }

  List<Solicitud> _solicitudes = [];
  Map<String, dynamic>? _simulacion;
  Map<String, dynamic>? _solicitudDetalle;
  List<Map<String, dynamic>> _cronograma = [];
  bool _isLoading = false;
  String? _error;

  List<Solicitud> get solicitudes => _solicitudes;
  Map<String, dynamic>? get simulacion => _simulacion;
  Map<String, dynamic>? get solicitudDetalle => _solicitudDetalle;
  List<Map<String, dynamic>> get cronograma => _cronograma;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarMisSolicitudes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _solicitudes = await _repository.listarMisSolicitudes();
    } catch (e) {
      _error = 'Error al cargar solicitudes';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarDetalleSolicitud(String expediente) async {
    _isLoading = true;
    notifyListeners();
    try {
      _solicitudDetalle = await _repository.obtenerSolicitud(expediente);
    } catch (e) {
      _error = 'Error al cargar detalle';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarCronograma(String expediente) async {
    _isLoading = true;
    notifyListeners();
    try {
      _cronograma = await _repository.obtenerCronograma(expediente);
    } catch (e) {
      _error = 'Error al cargar cronograma';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<String> enviarSolicitud(Map<String, dynamic> data) async {
    final result = await _repository.crearSolicitud(data);
    return result['numero_expediente'];
  }
}
