import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../services/api_client.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../model/cliente_cartera.dart';

final carteraProvider = ChangeNotifierProvider<CarteraState>((ref) => CarteraState());

class CarteraState extends ChangeNotifier {
  List<ClienteCartera> _clientes = [];
  bool _isLoading = false;
  String? _error;

  List<ClienteCartera> get clientes => _clientes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get total => _clientes.length;
  int get visitados => _clientes.where((c) => c.visitado).length;

  Future<void> cargar() async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await ApiClient.get('/cartera/fv');
      final data = result['data'] as List<dynamic>;
      _clientes = data.map((e) => ClienteCartera.fromJson(e as Map<String, dynamic>)).toList();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar cartera';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> marcarVisitado(String id) async {
    try {
      await ApiClient.post('/cartera/$id/checkin', {'lat': 0, 'lng': 0});
      final idx = _clientes.indexWhere((c) => c.id == id);
      if (idx >= 0) {
        _clientes[idx].visitado = true;
        notifyListeners();
      }
    } catch (_) {}
  }
}

class CarteraScreen extends ConsumerStatefulWidget {
  const CarteraScreen({super.key});

  @override
  ConsumerState<CarteraScreen> createState() => _CarteraScreenState();
}

class _CarteraScreenState extends ConsumerState<CarteraScreen> {
  String _filtro = 'Todos';
  final List<String> _filtros = ['Todos', 'Renovacion', 'Nuevas', 'En mora', 'Visitados'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(carteraProvider).cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final cartera = ref.watch(carteraProvider);

    final clientesFiltrados = cartera.clientes.where((c) {
      if (_filtro == 'Visitados') return c.visitado;
      if (_filtro == 'Renovacion') return c.tipoGestion == 'RENOVACION';
      if (_filtro == 'Nuevas') return c.tipoGestion == 'NUEVA_SOLICITUD';
      if (_filtro == 'En mora') return c.tipoGestion == 'RECUPERACION_MORA';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${auth.nombres ?? "Oficial"} ${auth.apellidos ?? ""}'),
        backgroundColor: IncasurTheme.azulProfundo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(carteraProvider).cargar(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () { auth.logout(); context.go('/login'); },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: IncasurTheme.azulProfundo.withAlpha(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _indicador('${cartera.total}', 'Total'),
                _indicador('${cartera.visitados}', 'Visitados'),
                _indicador('${cartera.total - cartera.visitados}', 'Pendientes'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filtros.map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: _filtro == f,
                    onSelected: (_) => setState(() => _filtro = f),
                    selectedColor: IncasurTheme.azulProfundo,
                    labelStyle: TextStyle(color: _filtro == f ? Colors.white : IncasurTheme.azulProfundo),
                  ),
                )).toList(),
              ),
            ),
          ),
          Expanded(
            child: cartera.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: clientesFiltrados.length,
                    itemBuilder: (_, i) {
                      final c = clientesFiltrados[i];
                      return _clienteCard(c, cartera, context);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _indicador(String valor, String label) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  Color _colorGestion(String tipo) {
    switch (tipo) {
      case 'RENOVACION': return Colors.blue;
      case 'AMPLIACION': return Colors.green;
      case 'NUEVA_SOLICITUD': return Colors.orange;
      case 'SEGUIMIENTO': return Colors.grey;
      case 'RECUPERACION_MORA': return Colors.red;
      case 'DESERTOR': return Colors.purple;
      default: return Colors.grey;
    }
  }

  Widget _clienteCard(ClienteCartera c, CarteraState cartera, BuildContext context) {
    final color = _colorGestion(c.tipoGestion);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: c.visitado ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/ficha', extra: c),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.person, color: color, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.nombre, style: const TextStyle(fontWeight: FontWeight.w600, color: IncasurTheme.azulProfundo)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(c.tipoGestion.replaceAll('_', ' '), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.circle, size: 6, color: c.prioridad == 'alta' ? Colors.red : c.prioridad == 'media' ? Colors.orange : Colors.green),
                          const SizedBox(width: 4),
                          Text(c.prioridad, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                        ],
                      ),
                      if (c.solicitud != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.description, size: 12, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text(c.solicitud!.numeroExpediente, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                            const Spacer(),
                            Text('S/ ${c.solicitud!.montoSolicitado.toStringAsFixed(0)}',
                              style: TextStyle(color: IncasurTheme.verdeAndino, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (c.visitado)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)
                else
                  IconButton(
                    icon: Icon(Icons.check_circle_outline, color: Colors.grey[300]),
                    onPressed: () => cartera.marcarVisitado(c.id),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
