-- ============================================================
-- CRAC Incasur - Migración a Supabase Auth
-- PASO 1: Trigger y RLS (sin foreign keys - seguro de aplicar)
-- ============================================================

-- 1. Trigger: crear fila en usuarios cuando se registra un auth user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.usuarios (id, dni, rol, clave_hash)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data ->> 'dni',
    COALESCE(NEW.raw_user_meta_data ->> 'rol', 'cliente'),
    NEW.encrypted_password
  )
  ON CONFLICT (id) DO UPDATE SET
    dni = EXCLUDED.dni,
    rol = EXCLUDED.rol;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 2. Añadir columna email a usuarios
ALTER TABLE public.usuarios ADD COLUMN IF NOT EXISTS email TEXT;

-- 3. RLS actualizadas
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS usuarios_select_policy ON public.usuarios;
CREATE POLICY usuarios_select_policy ON public.usuarios
  FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS usuarios_insert_policy ON public.usuarios;
CREATE POLICY usuarios_insert_policy ON public.usuarios
  FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS usuarios_update_policy ON public.usuarios;
CREATE POLICY usuarios_update_policy ON public.usuarios
  FOR UPDATE USING (auth.uid() = id);

-- 4. clientes_ficha RLS
DROP POLICY IF EXISTS clientes_ficha_select_policy ON public.clientes_ficha;
CREATE POLICY clientes_ficha_select_policy ON public.clientes_ficha
  FOR SELECT USING (auth.uid() = usuario_id);

DROP POLICY IF EXISTS clientes_ficha_insert_policy ON public.clientes_ficha;
CREATE POLICY clientes_ficha_insert_policy ON public.clientes_ficha
  FOR INSERT WITH CHECK (auth.uid() = usuario_id);

DROP POLICY IF EXISTS clientes_ficha_update_policy ON public.clientes_ficha;
CREATE POLICY clientes_ficha_update_policy ON public.clientes_ficha
  FOR UPDATE USING (auth.uid() = usuario_id);

-- 5. cartera_diaria RLS
DROP POLICY IF EXISTS cartera_diaria_select_policy ON public.cartera_diaria;
CREATE POLICY cartera_diaria_select_policy ON public.cartera_diaria
  FOR SELECT USING (auth.uid() = asesor_id);

DROP POLICY IF EXISTS cartera_diaria_insert_policy ON public.cartera_diaria;
CREATE POLICY cartera_diaria_insert_policy ON public.cartera_diaria
  FOR INSERT WITH CHECK (auth.uid() = asesor_id);

-- 6. solicitudes_credito RLS
DROP POLICY IF EXISTS solicitudes_credito_select_policy ON public.solicitudes_credito;
CREATE POLICY solicitudes_credito_select_policy ON public.solicitudes_credito
  FOR SELECT USING (
    auth.uid() = asesor_id
    OR auth.uid() IN (SELECT usuario_id FROM public.clientes_ficha WHERE id = cliente_id)
  );

DROP POLICY IF EXISTS solicitudes_credito_insert_policy ON public.solicitudes_credito;
CREATE POLICY solicitudes_credito_insert_policy ON public.solicitudes_credito
  FOR INSERT WITH CHECK (auth.uid() = asesor_id);

DROP POLICY IF EXISTS solicitudes_credito_update_policy ON public.solicitudes_credito;
CREATE POLICY solicitudes_credito_update_policy ON public.solicitudes_credito
  FOR UPDATE USING (
    auth.uid() = asesor_id
    OR auth.uid() IN (SELECT usuario_id FROM public.clientes_ficha WHERE id = cliente_id)
  );

-- 7. cronogramas RLS
DROP POLICY IF EXISTS cronogramas_select_policy ON public.cronogramas;
CREATE POLICY cronogramas_select_policy ON public.cronogramas
  FOR SELECT USING (
    auth.uid() IN (
      SELECT s.asesor_id FROM public.solicitudes_credito s WHERE s.id = solicitud_id
      UNION
      SELECT cf.usuario_id FROM public.solicitudes_credito s
        JOIN public.clientes_ficha cf ON cf.id = s.cliente_id
        WHERE s.id = solicitud_id
    )
  );

-- 8. sync_outbox RLS (sin cambios)
DROP POLICY IF EXISTS sync_outbox_select_policy ON public.sync_outbox;
CREATE POLICY sync_outbox_select_policy ON public.sync_outbox
  FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS sync_outbox_insert_policy ON public.sync_outbox;
CREATE POLICY sync_outbox_insert_policy ON public.sync_outbox
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
