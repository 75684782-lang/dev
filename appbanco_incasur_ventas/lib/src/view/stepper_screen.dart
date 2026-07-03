import 'dart:math' as math;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../services/api_client.dart';
import '../model/cliente_cartera.dart';

class StepperScreen extends ConsumerStatefulWidget {
  final ClienteCartera? cliente;
  const StepperScreen({super.key, this.cliente});

  @override
  ConsumerState<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends ConsumerState<StepperScreen> {
  int _currentStep = 0;
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();

  final _dniCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _negocioCtrl = TextEditingController();
  final _ingresosDiariosCtrl = TextEditingController();
  final _ingresosMensualesCtrl = TextEditingController();
  final _costosMercaderiaCtrl = TextEditingController();
  final _gastosFamiliaresCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _plazoCtrl = TextEditingController();
  final _garantiaCtrl = TextEditingController();
  final _destinoCtrl = TextEditingController();

  bool _conDesgravamen = true;
  double _cuotaCalculada = 0;
  double _excedenteFamiliar = 0;
  double _cobertura = 0;
  bool _capacidadSuficiente = false;
  bool _formularioBloqueado = false;
  bool _mostrarWarningRevisar = false;
  String? _mensajeValidacion;
  bool _enviando = false;
  String? _expedienteGenerado;
  bool _isLoading = false;

  Map<String, dynamic>? _buroResult;
  String? _clienteId;
  String? _solicitudId;
  bool _modoActualizacion = false;

  final _picker = ImagePicker();
  final _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );

  Map<String, File?> _fotos = {
    'dni_anverso': null,
    'dni_reverso': null,
    'ruc': null,
    'licencia': null,
    'boleta': null,
    'local': null,
  };
  Map<String, Position?> _fotoLocations = {};
  Map<String, bool> _fotoSubiendo = {};
  bool _firmaCompletada = false;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    if (c != null) {
      _nombreCtrl.text = c.nombreCompleto;
      _telefonoCtrl.text = c.telefono;
      _negocioCtrl.text = c.negocio;
      if (c.ingresosEstimados != null) {
        _ingresosDiariosCtrl.text = (c.ingresosEstimados! / 30).toStringAsFixed(0);
        _ingresosMensualesCtrl.text = c.ingresosEstimados!.toStringAsFixed(0);
      }
      if (c.gastosEstimados != null) {
        _gastosFamiliaresCtrl.text = c.gastosEstimados!.toStringAsFixed(0);
      }
    }
    _modoActualizacion = c?.solicitud != null;
    if (_modoActualizacion) {
      final sol = c!.solicitud!;
      _solicitudId = sol.numeroExpediente;
      _montoCtrl.text = sol.montoSolicitado.toStringAsFixed(0);
      _plazoCtrl.text = sol.plazoMeses.toString();
      _garantiaCtrl.text = sol.garantia;
      _destinoCtrl.text = sol.destinoCredito;
      _conDesgravamen = sol.conDesgravamen;
    }
  }

  @override
  void dispose() {
    _dniCtrl.dispose();
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    _negocioCtrl.dispose();
    _ingresosDiariosCtrl.dispose();
    _ingresosMensualesCtrl.dispose();
    _costosMercaderiaCtrl.dispose();
    _gastosFamiliaresCtrl.dispose();
    _montoCtrl.dispose();
    _plazoCtrl.dispose();
    _garantiaCtrl.dispose();
    _destinoCtrl.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  bool get _esInhabilitado => _buroResult != null && _buroResult!['inhabilitado'] == true;

  static int _plazoDefault(String? garantia) {
    if (garantia == null || garantia.isEmpty) return 6;
    final g = garantia.toUpperCase();
    if (g.contains('PRENDARIA') || g.contains('VEHICULO') || g.contains('MAQUINARIA')) return 12;
    if (g.contains('HIPOTECARIA') || g.contains('INMUEBLE')) return 24;
    return 6;
  }

  String get _preEvaluacion {
    if (_cobertura >= 130) return 'APTO';
    if (_cobertura >= 100) return 'REVISAR';
    return 'NO_PROCEDE';
  }

  void _calculatePlazoFromGarantia() {
    if (_garantiaCtrl.text.isNotEmpty && _plazoCtrl.text.isEmpty) {
      _plazoCtrl.text = _plazoDefault(_garantiaCtrl.text).toString();
    }
  }

  void _calcularSimulacion() {
    final monto = double.tryParse(_montoCtrl.text) ?? 0;
    final plazo = int.tryParse(_plazoCtrl.text) ?? 1;
    final ingresos = double.tryParse(_ingresosMensualesCtrl.text) ?? 0;
    final costos = double.tryParse(_costosMercaderiaCtrl.text) ?? 0;
    final gastos = double.tryParse(_gastosFamiliaresCtrl.text) ?? 0;
    if (monto <= 0 || plazo <= 0) return;

    final tea = _conDesgravamen ? 40.92 : 43.92;
    final tem = math.pow(1 + tea / 100, 1 / 12) - 1;
    _cuotaCalculada = monto * (tem * math.pow(1 + tem, plazo)) / (math.pow(1 + tem, plazo) - 1);

    _excedenteFamiliar = ingresos - costos - gastos;
    _cobertura = _cuotaCalculada > 0 ? _excedenteFamiliar / _cuotaCalculada * 100 : 0;

    final evaluacion = _preEvaluacion;
    _capacidadSuficiente = evaluacion == 'APTO' || evaluacion == 'REVISAR';
    _mostrarWarningRevisar = evaluacion == 'REVISAR';

    switch (evaluacion) {
      case 'APTO':
        _mensajeValidacion = 'Capacidad de pago suficiente (${_cobertura.toStringAsFixed(0)}%)';
        break;
      case 'REVISAR':
        _mensajeValidacion = 'Capacidad de pago ajustada (${_cobertura.toStringAsFixed(1)}%) - requiere revisión';
        break;
      case 'NO_PROCEDE':
        _mensajeValidacion = 'Capacidad de pago insuficiente. Cobertura: ${_cobertura.toStringAsFixed(1)}%';
        break;
    }
    _formularioBloqueado = evaluacion == 'NO_PROCEDE' || _esInhabilitado;
    setState(() {});
  }

  Future<void> _consultarBuro() async {
    setState(() => _isLoading = true);
    try {
      final result = await ApiClient.get('/buro/${_dniCtrl.text}');
      _buroResult = Map<String, dynamic>.from(result);
      if (_esInhabilitado) {
        _formularioBloqueado = true;
        _mensajeValidacion = 'CLIENTE EN LISTA DE INHABILITADOS - No puede continuar';
      }
    } catch (_) {
      _buroResult = null;
    }
    setState(() => _isLoading = false);
  }

  String? _errorEnvio;

  Future<String?> _subirFoto(String tipo, File file) async {
    try {
      setState(() => _fotoSubiendo[tipo] = true);
      final ext = file.path.split('.').last;
      final path = 'solicitudes/${DateTime.now().millisecondsSinceEpoch}_$tipo.$ext';
      await Supabase.instance.client.storage.from('solicitudes').upload(path, file);
      final url = Supabase.instance.client.storage.from('solicitudes').getPublicUrl(path);
      setState(() => _fotoSubiendo[tipo] = false);
      return url;
    } catch (e) {
      setState(() => _fotoSubiendo[tipo] = false);
      return null;
    }
  }

  Future<void> _tomarFoto(String tipo) async {
    final file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file == null) return;
    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {}
    setState(() {
      _fotos[tipo] = File(file.path);
      if (pos != null) _fotoLocations[tipo] = pos;
    });
  }

  Future<void> _enviarSolicitud() async {
    setState(() { _enviando = true; _errorEnvio = null; });
    try {
      final payload = {
        if (widget.cliente?.clienteFichaId != null) 'cliente_id': widget.cliente!.clienteFichaId,
        'monto_solicitado': double.parse(_montoCtrl.text),
        'plazo_meses': int.parse(_plazoCtrl.text),
        'con_desgravamen': _conDesgravamen,
        'garantia': _garantiaCtrl.text,
        'destino_credito': _destinoCtrl.text,
      };

      if (_modoActualizacion && _solicitudId != null) {
        await ApiClient.put('/solicitudes/$_solicitudId', payload);
        setState(() => _expedienteGenerado = _solicitudId);
      } else {
        final result = await ApiClient.post('/solicitudes/', payload);
        final solicitudId = result['id'];
        setState(() => _expedienteGenerado = result['numero_expediente']);

        // Upload photos
        for (final entry in _fotos.entries) {
          if (entry.value != null) {
            final url = await _subirFoto(entry.key, entry.value!);
            if (url != null && solicitudId != null) {
              try {
                await Supabase.instance.client.from('solicitudes_documentos').insert({
                  'solicitud_id': solicitudId,
                  'tipo_documento': entry.key,
                  'storage_url': url,
                });
              } catch (_) {}
            }
          }
        }

        // Upload signature if completed
          if (_firmaCompletada) {
            final sigBytes = await _signatureController.toPngBytes();
            if (sigBytes != null && solicitudId != null) {
              final dir = await path_provider.getTemporaryDirectory();
              final sigFile = File('${dir.path}/firma_${DateTime.now().millisecondsSinceEpoch}.png');
              await sigFile.writeAsBytes(sigBytes);
              final sigPath = 'solicitudes/firma_${DateTime.now().millisecondsSinceEpoch}.png';
              await Supabase.instance.client.storage.from('solicitudes').upload(sigPath, sigFile);
              await Supabase.instance.client.from('solicitudes_credito').update({
                'firma_cliente_base64': base64Encode(sigBytes),
              }).eq('id', solicitudId);
              await sigFile.delete();
            }
          }
      }
    } catch (e) {
      _errorEnvio = 'Error al enviar: $e';
    }
    setState(() => _enviando = false);
  }

  Color _preEvaluacionColor() {
    switch (_preEvaluacion) {
      case 'APTO': return IncasurTheme.verdeAndino;
      case 'REVISAR': return IncasurTheme.naranja;
      case 'NO_PROCEDE': return IncasurTheme.rojo;
      default: return Colors.grey;
    }
  }

  IconData _preEvaluacionIcon() {
    switch (_preEvaluacion) {
      case 'APTO': return Icons.check_circle;
      case 'REVISAR': return Icons.warning_amber_rounded;
      case 'NO_PROCEDE': return Icons.cancel;
      default: return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_expedienteGenerado != null) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Image.asset('assets/logo.png', height: 32),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: IncasurTheme.verdeAndino.withAlpha(25),
                ),
                child: const Icon(Icons.check_circle, size: 60, color: IncasurTheme.verdeAndino),
              ),
              const SizedBox(height: 24),
              const Text('¡Solicitud Enviada!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: IncasurTheme.azulOscuro)),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      const Text('Expediente', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(_expedienteGenerado!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: IncasurTheme.azulProfundo)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Image.asset('assets/logo.png', height: 32),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: IncasurTheme.azulProfundo),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: IncasurTheme.azulProfundo.withAlpha(13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Consultando buró...', style: TextStyle(fontSize: 15, color: IncasurTheme.azulProfundo, fontWeight: FontWeight.w600)),
                ),
              ],
            ))
          : Stepper(
                currentStep: _currentStep,
                onStepContinue: () async {
                  if (_currentStep == 0 && _form1Key.currentState!.validate()) {
                    final diario = double.tryParse(_ingresosDiariosCtrl.text) ?? 0;
                    if (diario > 0 && _ingresosMensualesCtrl.text.isEmpty) {
                      _ingresosMensualesCtrl.text = (diario * 30).toStringAsFixed(0);
                    }
                    _calculatePlazoFromGarantia();
                    setState(() => _currentStep++);
                  } else if (_currentStep == 1 && _form2Key.currentState!.validate()) {
                    _calcularSimulacion();
                    await _consultarBuro();
                    if (!_formularioBloqueado) {
                      setState(() => _currentStep++);
                    }
                  } else if (_currentStep == 2) {
                    setState(() => _currentStep++);
                  } else if (_currentStep == 3) {
                    setState(() => _currentStep++);
                  } else if (_currentStep == 4) {
                    await _enviarSolicitud();
                    if (_expedienteGenerado != null) {
                      setState(() => _currentStep++);
                    }
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) setState(() => _currentStep--);
                },
                controlsBuilder: (context, details) {
                  bool isLastStep = _currentStep >= 4;
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        if (_currentStep < 5)
                          ElevatedButton(
                            onPressed: _enviando ? null : details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 4,
                              shadowColor: IncasurTheme.azulProfundo.withAlpha(80),
                            ),
                            child: _enviando
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Text(
                                    isLastStep ? 'Enviar a Gerencia' : 'Continuar',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                          ),
                        if (_currentStep > 0 && !isLastStep) ...[
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: details.onStepCancel,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              side: BorderSide(color: IncasurTheme.azulProfundo.withAlpha(80)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text('Atrás', style: TextStyle(color: IncasurTheme.azulProfundo, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('Datos Generales', style: TextStyle(fontWeight: FontWeight.w700)),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                    content: Form(
                      key: _form1Key,
                      child: Column(children: [
                        TextFormField(
                          controller: _dniCtrl,
                          decoration: InputDecoration(
                            labelText: 'DNI',
                            prefixIcon: Icon(Icons.badge_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number, maxLength: 8,
                          readOnly: _modoActualizacion,
                          validator: (v) => (!_modoActualizacion && v!.length != 8) ? 'DNI debe tener 8 dígitos' : null,
                        ),
                        if (_modoActualizacion) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: IncasurTheme.azulProfundo.withAlpha(10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.person, size: 18, color: IncasurTheme.azulProfundo),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text('${widget.cliente!.nombreCompleto} | ${widget.cliente!.telefono}',
                                    style: TextStyle(color: IncasurTheme.azulProfundo, fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextFormField(controller: _nombreCtrl,
                          decoration: InputDecoration(
                            labelText: 'Nombre Completo',
                            prefixIcon: Icon(Icons.person_outline, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null),
                        const SizedBox(height: 14),
                        TextFormField(controller: _telefonoCtrl,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: Icon(Icons.phone_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) => v!.isEmpty ? 'Requerido' : null),
                        const SizedBox(height: 14),
                        TextFormField(controller: _negocioCtrl,
                          decoration: InputDecoration(
                            labelText: 'Nombre del Negocio',
                            prefixIcon: Icon(Icons.store_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null),
                        const SizedBox(height: 14),
                        TextFormField(controller: _ingresosDiariosCtrl,
                          decoration: InputDecoration(
                            labelText: 'Ingresos diarios estimados (S/)',
                            prefixIcon: Icon(Icons.trending_up, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number),
                      ]),
                    ),
                  ),
                  Step(
                    title: const Text('Análisis Financiero', style: TextStyle(fontWeight: FontWeight.w700)),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                    content: Form(
                      key: _form2Key,
                      child: Column(children: [
                        if (_mensajeValidacion != null && _currentStep == 1 && _formularioBloqueado) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: IncasurTheme.rojo.withAlpha(15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: IncasurTheme.rojo.withAlpha(60)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning, color: IncasurTheme.rojo, size: 22),
                                const SizedBox(width: 12),
                                Expanded(child: Text(_mensajeValidacion!, style: TextStyle(color: IncasurTheme.rojo, fontSize: 13, fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        TextFormField(controller: _ingresosMensualesCtrl,
                          decoration: InputDecoration(
                            labelText: 'Ingresos Mensuales (S/)',
                            prefixIcon: Icon(Icons.account_balance, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (double.tryParse(v) == null) return 'Ingrese un número válido';
                            return null;
                          }),
                        const SizedBox(height: 14),
                        TextFormField(controller: _costosMercaderiaCtrl,
                          decoration: InputDecoration(
                            labelText: 'Costos de Mercadería (S/)',
                            prefixIcon: Icon(Icons.shopping_cart_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (double.tryParse(v) == null) return 'Ingrese un número válido';
                            return null;
                          }),
                        const SizedBox(height: 14),
                        TextFormField(controller: _gastosFamiliaresCtrl,
                          decoration: InputDecoration(
                            labelText: 'Gastos Familiares (S/)',
                            prefixIcon: Icon(Icons.home_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (double.tryParse(v) == null) return 'Ingrese un número válido';
                            return null;
                          }),
                        const SizedBox(height: 14),
                        TextFormField(controller: _montoCtrl,
                          decoration: InputDecoration(
                            labelText: 'Monto Solicitado (S/)',
                            prefixIcon: Icon(Icons.monetization_on_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (double.tryParse(v) == null) return 'Ingrese un número válido';
                            return null;
                          }),
                        const SizedBox(height: 14),
                        TextFormField(controller: _plazoCtrl,
                          decoration: InputDecoration(
                            labelText: 'Plazo (meses)',
                            prefixIcon: Icon(Icons.timer_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (int.tryParse(v) == null) return 'Ingrese un número entero';
                            return null;
                          }),
                        const SizedBox(height: 14),
                        TextFormField(controller: _garantiaCtrl,
                          decoration: InputDecoration(
                            labelText: 'Garantía',
                            hintText: 'Ej: Prendaria, Hipotecaria, Solidaria',
                            prefixIcon: Icon(Icons.shield_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          onChanged: (_) => _calculatePlazoFromGarantia(),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null),
                        const SizedBox(height: 14),
                        TextFormField(controller: _destinoCtrl,
                          decoration: InputDecoration(
                            labelText: 'Destino del Crédito',
                            hintText: 'Ej: Capital de trabajo, Activo fijo',
                            prefixIcon: Icon(Icons.flag_outlined, color: IncasurTheme.azulProfundo),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (v) => v!.isEmpty ? 'Requerido' : null),
                        const SizedBox(height: 14),
                        Card(
                          elevation: 0,
                          color: IncasurTheme.azulProfundo.withAlpha(8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: SwitchListTile(
                            title: const Text('Seguro de Desgravamen', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                            subtitle: const Text('TEA 40.92% con seguro / 43.92% sin seguro', style: TextStyle(fontSize: 12)),
                            value: _conDesgravamen,
                            activeColor: IncasurTheme.verdeAndino,
                            activeTrackColor: IncasurTheme.verdeAndino.withAlpha(80),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            onChanged: (v) => setState(() => _conDesgravamen = v),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Step(
                    title: const Text('Simulador', style: TextStyle(fontWeight: FontWeight.w700)),
                    isActive: _currentStep >= 2,
                    state: _formularioBloqueado ? StepState.error : (_currentStep > 2 ? StepState.complete : StepState.indexed),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_buroResult != null) ...[
                          Card(
                            elevation: 4,
                            shadowColor: IncasurTheme.azulProfundo.withAlpha(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: const LinearGradient(
                                  colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 36, height: 36,
                                          decoration: BoxDecoration(
                                            color: _esInhabilitado ? IncasurTheme.rojo.withAlpha(80) : Colors.white.withAlpha(25),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.account_balance, color: _esInhabilitado ? Colors.white : Colors.white70, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text('Buró SBS', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buroRow('Calificación', '${_buroResult!['calificacion']}'),
                                    const SizedBox(height: 8),
                                    _buroRow('Entidades con deuda', '${_buroResult!['entidades_con_deuda']}'),
                                    const SizedBox(height: 8),
                                    _buroRow('Deuda total', 'S/ ${(_buroResult!['deuda_total'] as num).toStringAsFixed(2)}'),
                                    const SizedBox(height: 8),
                                    _buroRow('Días de mayor mora', '${_buroResult!['dias_mayor_mora']}'),
                                    if (_esInhabilitado) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: IncasurTheme.rojo.withAlpha(100),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.block, color: Colors.white, size: 20),
                                            SizedBox(width: 8),
                                            Text('LISTA DE INHABILITADOS', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_cuotaCalculada > 0) ...[
                          Card(
                            elevation: 6,
                            shadowColor: IncasurTheme.verdeAndino.withAlpha(60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [IncasurTheme.verdeAndino, Color(0xFF1B5E20)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Column(children: [
                                const Text('Cuota Fija Mensual', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Text('S/ ${_cuotaCalculada.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(20),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _metricWidget('Excedente', 'S/ ${_excedenteFamiliar.toStringAsFixed(0)}'),
                                      Container(width: 1, height: 30, color: Colors.white.withAlpha(40)),
                                      _metricWidget('Cobertura', '${_cobertura.toStringAsFixed(1)}%'),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _preEvaluacionColor().withAlpha(15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _preEvaluacionColor().withAlpha(80), width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: _preEvaluacionColor().withAlpha(25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(_preEvaluacionIcon(), color: _preEvaluacionColor(), size: 26),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: _preEvaluacionColor(), fontSize: 14),
                                      children: [
                                        TextSpan(text: '$_preEvaluacion ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        TextSpan(text: _mensajeValidacion ?? ''),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_mostrarWarningRevisar) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: IncasurTheme.naranja.withAlpha(15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: IncasurTheme.naranja.withAlpha(60)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: IncasurTheme.naranja, size: 22),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text('Cobertura entre 100% y 130%: solicitud pasará a revisión de comité',
                                      style: TextStyle(color: IncasurTheme.naranja, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (_formularioBloqueado && !_esInhabilitado) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: IncasurTheme.rojo.withAlpha(15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: IncasurTheme.rojo.withAlpha(60)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning, color: IncasurTheme.rojo, size: 22),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text('Ajuste los valores financieros o reduzca el monto solicitado para continuar',
                                      style: TextStyle(color: IncasurTheme.rojo, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: 14),
                        if (_enviando) LinearProgressIndicator(color: IncasurTheme.azulProfundo, backgroundColor: IncasurTheme.azulProfundo.withAlpha(30)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'TEA: ${_conDesgravamen ? "40.92%" : "43.92%"} | Amortización Francesa | Garantía: ${_garantiaCtrl.text.isNotEmpty ? _garantiaCtrl.text : "—"}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Firma y Adjuntos', style: TextStyle(fontWeight: FontWeight.w700)),
                    isActive: _currentStep >= 3,
                    state: StepState.indexed,
                    content: Column(children: [
                      _fotoTile('dni_anverso', 'DNI Anverso', Icons.credit_card),
                      const SizedBox(height: 8),
                      _fotoTile('dni_reverso', 'DNI Reverso', Icons.credit_card),
                      const SizedBox(height: 8),
                      _fotoTile('ruc', 'RUC', Icons.assignment),
                      const SizedBox(height: 8),
                      _fotoTile('licencia', 'Licencia de Conducir', Icons.drive_eta),
                      const SizedBox(height: 8),
                      _fotoTile('boleta', 'Boleta/Recibo', Icons.receipt_long),
                      const SizedBox(height: 8),
                      _fotoTile('local', 'Foto del Local / Negocio', Icons.store),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Firma Digital', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: IncasurTheme.azulOscuro)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(color: _firmaCompletada ? IncasurTheme.verdeAndino : IncasurTheme.azulProfundo.withAlpha(50), width: 2),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Signature(
                            controller: _signatureController,
                            height: 156,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (_firmaCompletada)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: IncasurTheme.verdeAndino.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, size: 14, color: IncasurTheme.verdeAndino),
                                  const SizedBox(width: 4),
                                  const Text('Firmado', style: TextStyle(fontSize: 12, color: IncasurTheme.verdeAndino, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              _signatureController.clear();
                              setState(() => _firmaCompletada = false);
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                          ),
                          TextButton.icon(
                            onPressed: () => setState(() => _firmaCompletada = true),
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Confirmar', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: IncasurTheme.dorado.withAlpha(15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: IncasurTheme.dorado.withAlpha(50)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: IncasurTheme.dorado, size: 22),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text('Al firmar, el cliente acepta los términos y condiciones del crédito.',
                                style: TextStyle(fontSize: 13, color: IncasurTheme.azulOscuro, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Step(
                    title: const Text('Enviar a Gerencia', style: TextStyle(fontWeight: FontWeight.w700)),
                    isActive: _currentStep >= 4,
                    state: _errorEnvio != null ? StepState.error : (_currentStep > 4 ? StepState.complete : StepState.indexed),
                    content: Column(children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(Icons.description, color: IncasurTheme.azulProfundo),
                                const SizedBox(width: 10),
                                Text('Resumen', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: IncasurTheme.azulProfundo)),
                              ]),
                              const Divider(height: 24),
                              _resumenRow('Monto', 'S/ ${_montoCtrl.text}'),
                              _resumenRow('Plazo', '${_plazoCtrl.text} meses'),
                              _resumenRow('Cuota', 'S/ ${_cuotaCalculada.toStringAsFixed(2)}'),
                              _resumenRow('Evaluación', _preEvaluacion),
                              _resumenRow('Garantía', _garantiaCtrl.text),
                              _resumenRow('Destino', _destinoCtrl.text),
                            ],
                          ),
                        ),
                      ),
                      if (_errorEnvio != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: IncasurTheme.rojo.withAlpha(15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: IncasurTheme.rojo.withAlpha(60)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error, color: IncasurTheme.rojo, size: 22),
                              const SizedBox(width: 12),
                              Expanded(child: Text(_errorEnvio!, style: TextStyle(color: IncasurTheme.rojo, fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: IncasurTheme.azulProfundo.withAlpha(8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: IncasurTheme.azulProfundo, size: 22),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text('La solicitud será enviada al comité de créditos para su evaluación y aprobación.',
                                style: TextStyle(fontSize: 13, color: IncasurTheme.azulOscuro)),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
    );
  }

  Widget _buroRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _metricWidget(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _fotoTile(String tipo, String label, IconData icon) {
    final file = _fotos[tipo];
    final pos = _fotoLocations[tipo];
    final subiendo = _fotoSubiendo[tipo] ?? false;
    return Card(
      elevation: 2,
      shadowColor: IncasurTheme.azulProfundo.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _tomarFoto(tipo),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            if (file != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(file, width: 56, height: 56, fit: BoxFit.cover),
              )
            else
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: IncasurTheme.azulProfundo.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: IncasurTheme.azulProfundo, size: 24),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: IncasurTheme.azulOscuro)),
                  if (pos != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 2),
                        Text('${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}',
                          style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                      ],
                    ),
                  if (subiendo)
                    const Row(
                      children: [
                        SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5)),
                        SizedBox(width: 4),
                        Text('Subiendo...', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                ],
              ),
            ),
            if (subiendo)
              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5))
            else
              GestureDetector(
                onTap: () => _tomarFoto(tipo),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: file != null ? IncasurTheme.verdeAndino.withAlpha(20) : IncasurTheme.azulProfundo.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    file != null ? Icons.check : Icons.camera_alt,
                    size: 18, color: file != null ? IncasurTheme.verdeAndino : IncasurTheme.azulProfundo,
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _resumenRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: IncasurTheme.azulOscuro)),
        ],
      ),
    );
  }
}
