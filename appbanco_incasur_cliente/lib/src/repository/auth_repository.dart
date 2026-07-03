import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String dni, String clave) async {
    final email = '$dni@incasur.app';
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: clave,
    );
    final result = await Supabase.instance.client
        .from('usuarios')
        .select('id, rol')
        .eq('dni', dni)
        .single();
    return {
      'access_token': response.session!.accessToken,
      'rol': result['rol'],
      'usuario_id': result['id'],
    };
  }

  Future<Map<String, dynamic>> registro(Map<String, dynamic> data) async {
    final supabase = Supabase.instance.client;
    // Use signUp directly — the trigger handle_new_user inserts into usuarios
    await supabase.auth.signUp(
      email: '${data['dni']}@incasur.app',
      password: data['clave'],
      data: {'dni': data['dni'], 'rol': 'cliente'},
    );
    // Sign in with the new credentials
    final session = await supabase.auth.signInWithPassword(
      email: '${data['dni']}@incasur.app',
      password: data['clave'],
    );
    // Insert into clientes_ficha so FVentas can look up this client
    await supabase.from('clientes_ficha').insert({
      'usuario_id': session.user!.id,
      'nombre_completo': data['nombre_completo'],
      'telefono': data['telefono'],
      'negocio_nombre': data['negocio_nombre'] ?? '',
    });
    return {
      'access_token': session.session!.accessToken,
      'rol': 'cliente',
      'usuario_id': session.user!.id,
    };
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  static Future<bool> checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null;
  }

  static Future<Map<String, String?>> getSession() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {'usuario_id': null, 'rol': null};
    try {
      final result = await Supabase.instance.client
          .from('usuarios')
          .select('id, rol')
          .eq('id', user.id)
          .single();
      return {'usuario_id': result['id'], 'rol': result['rol']};
    } catch (_) {
      return {'usuario_id': null, 'rol': null};
    }
  }
}
