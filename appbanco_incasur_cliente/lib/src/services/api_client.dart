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

  static Future<Map<String, dynamic>> _serviceGet(String table, {String? query}) async {
    final uri = Uri.parse('$_supabaseUrl/rest/v1/$table${query != null ? '?$query' : ''}');
    final res = await http.get(uri, headers: _serviceHeaders);
    if (res.statusCode >= 400) throw Exception('GET $table failed: ${res.body}');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> _serviceGetList(String table, {String? query}) async {
    final uri = Uri.parse('$_supabaseUrl/rest/v1/$table${query != null ? '?$query' : ''}');
    final res = await http.get(uri, headers: _serviceHeaders);
    if (res.statusCode >= 400) throw Exception('GET $table failed: ${res.body}');
    return jsonDecode(res.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> _serviceInsert(String table, Map<String, dynamic> data) async {
    final uri = Uri.parse('$_supabaseUrl/rest/v1/$table');
    final res = await http.post(uri, headers: _serviceHeaders, body: jsonEncode(data));
    if (res.statusCode >= 400) throw Exception('INSERT $table failed: ${res.body}');
    final decoded = jsonDecode(res.body);
    if (decoded is List && decoded.isNotEmpty) return decoded[0] as Map<String, dynamic>;
    return decoded as Map<String, dynamic>;
  }

  static String _generateExpediente() {
    final rnd = Random();
    final suffix = rnd.nextInt(0xFFFF).toRadixString(16).toUpperCase().padLeft(4, '0');
    return 'EXP-2026-$suffix';
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    final parts = path.split('/').where((s) => s.isNotEmpty).toList();

    if (path == '/solicitudes/mias') {
      final ficha = await supabase
          .from('clientes_ficha')
          .select('id')
          .eq('usuario_id', user?.id ?? '')
          .maybeSingle();
      if (ficha == null) return {'data': []};
      final result = await supabase
          .from('solicitudes_credito')
          .select('*, clientes_ficha!inner(nombre_completo, telefono, negocio_nombre)')
          .eq('cliente_id', ficha['id'])
          .order('creado_en', ascending: false);
      return {'data': result};
    }

    if (parts.length == 2 && parts[0] == 'solicitudes') {
      final expediente = parts[1];
      final result = await supabase
          .from('solicitudes_credito')
          .select('*, clientes_ficha!inner(nombre_completo, telefono, negocio_nombre)')
          .eq('numero_expediente', expediente)
          .single();
      final cliente = result['clientes_ficha'] as Map<String, dynamic>?;
      return {
        'numero_expediente': result['numero_expediente'],
        'cliente': cliente?['nombre_completo'] ?? '',
        'monto_solicitado': result['monto_solicitado'],
        'plazo_meses': result['plazo_meses'],
        'tea': result['tea'],
        'estado': result['estado'],
        'linea_tiempo': null,
        'clientes_ficha': cliente,
      };
    }

    if (parts.length == 2 && parts[0] == 'cronograma') {
      final expediente = parts[1];
      final solResult = await supabase
          .from('solicitudes_credito')
          .select('id')
          .eq('numero_expediente', expediente)
          .single();
      final cuotas = await supabase
          .from('cronogramas')
          .select('*')
          .eq('solicitud_id', solResult['id'])
          .order('numero_cuota');
      return {'cronograma': cuotas};
    }

    throw Exception('Endpoint no implementado: $path');
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (path == '/solicitudes/solicitar') {
      final ficha = await supabase
          .from('clientes_ficha')
          .select('id')
          .eq('usuario_id', user?.id ?? '')
          .single();
      final expediente = _generateExpediente();
      final tea = (body['con_desgravamen'] as bool? ?? true) ? 40.92 : 43.92;

      final operadores = await _serviceGetList('usuarios', query: 'rol=eq.operador&select=id&limit=1');
      if (operadores.isEmpty) throw Exception('No hay operadores disponibles');
      final operadorId = operadores[0]['id'] as String;

      final result = await supabase.from('solicitudes_credito').insert({
        'numero_expediente': expediente,
        'cliente_id': ficha['id'],
        'asesor_id': operadorId,
        'monto_solicitado': body['monto_solicitado'],
        'plazo_meses': body['plazo_meses'] ?? 6,
        'tea': tea,
        'con_desgravamen': body['con_desgravamen'] ?? true,
        'garantia': body['garantia'] ?? '',
        'destino_credito': body['destino_credito'] ?? '',
        'estado': 'enviado',
      }).select().single();

      await supabase.from('cartera_diaria').insert({
        'asesor_id': operadorId,
        'cliente_id': ficha['id'],
        'tipo_gestion': 'NUEVA_SOLICITUD',
        'prioridad': 'media',
      });

      return {'numero_expediente': result['numero_expediente']};
    }

    throw Exception('Endpoint no implementado: $path');
  }

  static Future<void> setToken(String token) async {}
  static Future<String?> getToken() async {
    return Supabase.instance.client.auth.currentSession?.accessToken;
  }
  static Future<void> clearToken() async {}
}
