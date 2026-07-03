import json, urllib.request, urllib.error, urllib.parse
from supabase import create_client

SUPABASE_URL = 'https://jznjjmwzctpclilemryj.supabase.co'
SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6bmpqbXd6Y3RwY2xpbGVtcnlqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODE4MTIwNSwiZXhwIjoyMDkzNzU3MjA1fQ.jCkFPXVo7Uz2-VLsk6muzlljTDUF604T__lzcVvBrSc'

sb = create_client(SUPABASE_URL, SERVICE_KEY)

headers = {
    'apikey': SERVICE_KEY,
    'Authorization': 'Bearer {}'.format(SERVICE_KEY),
    'Content-Type': 'application/json',
}

result = sb.table('usuarios').select('*').execute()
users = result.data
print('Found {} existing users'.format(len(users)))

for user in users:
    dni = user['dni']
    email = '{}@incasur.app'.format(dni)
    password = 'incasur{}'.format(dni)
    rol = user['rol']

    print('  {} ({})'.format(dni, email))

    auth_id = None
    url = '{}/auth/v1/admin/users'.format(SUPABASE_URL)
    body_data = {
        'email': email,
        'password': password,
        'email_confirm': True,
        'user_metadata': {'dni': dni, 'rol': rol},
    }
    body = json.dumps(body_data).encode()

    try:
        req = urllib.request.Request(url, data=body, headers=headers, method='POST')
        resp = urllib.request.urlopen(req)
        auth_user = json.loads(resp.read())
        auth_id = auth_user['id']
        print('    created: {}'.format(auth_id))
    except urllib.error.HTTPError as e:
        err_body = e.read().decode()
        print('    HTTP {}: {}'.format(e.code, err_body[:200]))
        try:
            err_json = json.loads(err_body)
            msg = err_json.get('msg', err_json.get('error_description', err_json.get('error', '')))
            if 'already exists' in msg:
                encoded_email = urllib.parse.quote(email, safe='')
                list_url = '{}/auth/v1/admin/users?filter%5Bemail%5D=eq.{}'.format(SUPABASE_URL, encoded_email)
                list_req = urllib.request.Request(list_url, headers=headers)
                list_resp = urllib.request.urlopen(list_req)
                existing_list = json.loads(list_resp.read())
                if existing_list:
                    auth_id = existing_list[0]['id']
                    print('    exists: {}'.format(auth_id))
                else:
                    print('    ERROR: user not found by email search')
        except json.JSONDecodeError:
            print('    ERROR: could not parse response')

    if auth_id is None:
        print('    SKIPPED')
        continue

    sb.table('usuarios').update({'id': auth_id, 'email': email}).eq('dni', dni).execute()
    old_id = user['id']
    sb.table('clientes_ficha').update({'usuario_id': auth_id}).eq('usuario_id', old_id).execute()
    sb.table('solicitudes_credito').update({'asesor_id': auth_id}).eq('asesor_id', old_id).execute()
    sb.table('cartera_diaria').update({'asesor_id': auth_id}).eq('asesor_id', old_id).execute()
    print('    linked')

print()
print('Done!')
