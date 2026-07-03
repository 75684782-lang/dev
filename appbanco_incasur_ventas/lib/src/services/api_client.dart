import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  static const _supabaseUrl = 'https://jznjjmwzctpclilemryj.supabase.co';
  static const _serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6bmpqbXd6Y3RwY2xpbGVtcnlqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODE4MTIwNSwiZXhwIjoyMDkzNzU3MjA1fQ.jCkFPXVo7Uz2-VLsk6muzlljTDUF604T__lzcVvBrSc';

  static final Map<String, String> _serviceHeaders = {
    'apikey': _serviceRoleKey,
    'Authorization': 'Bearer $_serviceRoleKey',
    'Content-Type': 'application/json',
    'Prefer': 'return=representation',
  };

  static Future<List<dynamic>> _serviceGetList(String table, {String? query}) async {
    final uri = Uri.parse('$_supabaseUrl/rest/v1/$table${query != null ? '?$query' : ''}');
    final res = await http.get(uri, headers: _serviceHeaders);
    if (res.statusCode >= 400) throw Exception('GET $table failed: ${res.body}');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static final Map<String, Map<String, dynamic>> _sbsMock = {
    '0': {'calificacion': 'NORMAL', 'entidades': 1, 'deuda_total': 4500, 'dias_mora': 0, 'inhabilitado': false},
    '1': {'calificacion': 'NORMAL', 'entidades': 2, 'deuda_total': 12000, 'dias_mora': 0, 'inhabilitado': false},
    '2': {'calificacion': 'CPP', 'entidades': 2, 'deuda_total': 18000, 'dias_mora': 15, 'inhabilitado': false},
    '3': {'calificacion': 'NORMAL', 'entidades': 0, 'deuda_total': 0, 'dias_mora': 0, 'inhabilitado': false},
    '4': {'calificacion': 'DUDOSO', 'entidades': 3, 'deuda_total': 25000, 'dias_mora': 95, 'inhabilitado': false},
    '5': {'calificacion': 'DEFICIENTE', 'entidades': 2, 'deuda_total': 16000, 'dias_mora': 45, 'inhabilitado': false},
    '6': {'calificacion': 'NORMAL', 'entidades': 1, 'deuda_total': 6000, 'dias_mora': 0, 'inhabilitado': false},
    '7': {'calificacion': 'PERDIDA', 'entidades': 4, 'deuda_total': 40000, 'dias_mora': 210, 'inhabilitado': true},
    '8': {'calificacion': 'CPP', 'entidades': 1, 'deuda_total': 9000, 'dias_mora': 20, 'inhabilitado': false},
    '9': {'calificacion': 'NORMAL', 'entidades': 2, 'deuda_total': 14000, 'dias_mora': 0, 'inhabilitado': false},
  };

  static String _generateExpediente() {
    final rnd = Random();
    final suffix = rnd.nextInt(0xFFFF).toRadixString(16).toUpperCase().padLeft(4, '0');
    return 'EXP-2026-$suffix';
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final supabase = Supabase.instance.client;
    final parts = path.split('/').where((s) => s.isNotEmpty).toList();

    if (path == '/cartera/fv') {
      final data = await _serviceGetList('cartera_diaria',
          query: 'select=*,clientes_ficha!inner(id,nombre_completo,telefono,negocio_nombre,ingresos_estimados,gastos_estimados)&order=prioridad');

      final clientIds = data.map((e) => (e['clientes_ficha'] as Map)['id'] as String).toSet().toList();
      Map<String, Map<String, dynamic>> solicitudesPorCliente = {};
      if (clientIds.isNotEmpty) {
        final inClause = clientIds.join(',');
        final sols = await _serviceGetList('solicitudes_credito',
            query: 'select=*&cliente_id=in.($inClause)&order=creado_en.desc');
        for (final s in sols) {
          final cid = s['cliente_id'] as String;
          if (!solicitudesPorCliente.containsKey(cid)) {
            solicitudesPorCliente[cid] = Map<String, dynamic>.from(s);
          }
        }
      }

      final result = (data).map((row) {
        final Map<String, dynamic> rowMap = row as Map<String, dynamic>;
        final cliente = rowMap['clientes_ficha'] as Map<String, dynamic>;
        final cid = cliente['id'] as String;
        final sol = solicitudesPorCliente[cid];
        return {
          'id': rowMap['id'],
          'nombre': cliente['nombre_completo'],
          'telefono': cliente['telefono'],
          'negocio': cliente['negocio_nombre'],
          'tipo_gestion': rowMap['tipo_gestion'],
          'prioridad': rowMap['prioridad'],
          'visitado': rowMap['visitado'],
          'cliente_ficha_id': cid,
          'solicitud': sol,
          'ingresos_estimados': cliente['ingresos_estimados'],
          'gastos_estimados': cliente['gastos_estimados'],
        };
      }).toList();
      return {'data': result};
    }

    if (parts.length == 2 && parts[0] == 'buro') {
      final dni = parts[1];
      final ultimo = dni.isNotEmpty ? dni[dni.length - 1] : '0';
      final perfil = _sbsMock[ultimo] ?? _sbsMock['0']!;
      final result = {
        'dni': dni,
        'calificacion': perfil['calificacion'],
        'entidades_con_deuda': perfil['entidades'],
        'deuda_total': perfil['deuda_total'],
        'dias_mayor_mora': perfil['dias_mora'],
        'inhabilitado': perfil['inhabilitado'],
      };
      // Persist buro result
      try {
        await supabase.from('consultas_buro').insert({
          'dni': dni,
          'calificacion': perfil['calificacion'],
          'entidades_con_deuda': perfil['entidades'],
          'deuda_total': perfil['deuda_total'],
          'dias_mayor_mora': perfil['dias_mora'],
          'inhabilitado': perfil['inhabilitado'],
        });
      } catch (_) {}
      return result;
    }

    throw Exception('Endpoint no implementado: GET $path');
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final supabase = Supabase.instance.client;
    final parts = path.split('/').where((s) => s.isNotEmpty).toList();

    if (parts.length == 3 && parts[0] == 'cartera' && parts[2] == 'checkin') {
      final id = parts[1];
      await supabase.from('cartera_diaria').update({'visitado': true}).eq('id', id);
      return {};
    }

    if (path == '/solicitudes/') {
      final userId = supabase.auth.currentUser?.id;
      final clienteId = body['cliente_id'] as String?;
      if (clienteId == null || clienteId.isEmpty) {
        throw Exception('cliente_id es requerido para crear la solicitud');
      }

      final expediente = _generateExpediente();
      final tea = (body['con_desgravamen'] as bool? ?? true) ? 40.92 : 43.92;

      final result = await supabase.from('solicitudes_credito').insert({
        'numero_expediente': expediente,
        'cliente_id': clienteId,
        'asesor_id': userId,
        'monto_solicitado': body['monto_solicitado'],
        'plazo_meses': body['plazo_meses'],
        'tea': tea,
        'con_desgravamen': body['con_desgravamen'] ?? true,
        'garantia': body['garantia'] ?? '',
        'destino_credito': body['destino_credito'] ?? '',
        'estado': 'enviado',
      }).select().single();

      await supabase.from('cartera_diaria').insert({
        'asesor_id': userId,
        'cliente_id': clienteId,
        'tipo_gestion': 'NUEVA_SOLICITUD',
        'prioridad': 'media',
      });

      return {'numero_expediente': result['numero_expediente']};
    }

    if (path == '/sync/outbox') {
      return {};
    }

    throw Exception('Endpoint no implementado: POST $path');
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final supabase = Supabase.instance.client;
    final parts = path.split('/').where((s) => s.isNotEmpty).toList();

    if (parts.length == 2 && parts[0] == 'solicitudes') {
      final expediente = parts[1];
      await supabase.from('solicitudes_credito').update({
        'monto_solicitado': body['monto_solicitado'],
        'plazo_meses': body['plazo_meses'],
        'con_desgravamen': body['con_desgravamen'],
        'garantia': body['garantia'],
        'destino_credito': body['destino_credito'],
        'estado': 'recibido_comite',
      }).eq('numero_expediente', expediente);
      return {};
    }

    throw Exception('Endpoint no implementado: PUT $path');
  }

  static Future<List<dynamic>> getList(String path) async {
    final result = await get(path);
    return result['data'] as List<dynamic>? ?? [];
  }

  static Future<String?> getToken() async {
    return Supabase.instance.client.auth.currentSession?.accessToken;
  }

  static Future<void> setToken(String token) async {}
  static Future<void> clearToken() async {}
}
