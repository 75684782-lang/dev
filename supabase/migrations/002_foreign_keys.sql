-- ============================================================
-- CRAC Incasur - PASO 2: Foreign keys y unique constraint
-- Ejecutar DESPUÉS de migrar usuarios existentes a Supabase Auth
-- ============================================================

-- 1. Re-add unique constraint on dni
ALTER TABLE public.usuarios ADD CONSTRAINT usuarios_dni_key UNIQUE (dni);

-- 2. Re-create trigger after migration
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 3. clientes_ficha FK -> usuarios
ALTER TABLE public.clientes_ficha DROP CONSTRAINT IF EXISTS clientes_ficha_usuario_id_fkey CASCADE;
ALTER TABLE public.clientes_ficha ADD CONSTRAINT clientes_ficha_usuario_id_fkey
  FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;

-- 4. solicitudes_credito FK -> usuarios
ALTER TABLE public.solicitudes_credito DROP CONSTRAINT IF EXISTS solicitudes_credito_asesor_id_fkey CASCADE;
ALTER TABLE public.solicitudes_credito ADD CONSTRAINT solicitudes_credito_asesor_id_fkey
  FOREIGN KEY (asesor_id) REFERENCES public.usuarios(id);

-- 5. cartera_diaria FK -> usuarios
ALTER TABLE public.cartera_diaria DROP CONSTRAINT IF EXISTS cartera_diaria_asesor_id_fkey CASCADE;
ALTER TABLE public.cartera_diaria ADD CONSTRAINT cartera_diaria_asesor_id_fkey
  FOREIGN KEY (asesor_id) REFERENCES public.usuarios(id);
