import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "npm:@supabase/supabase-js@^2";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const { dni, clave, nombre_completo, telefono, negocio_nombre } = await req.json();

    if (!dni || !clave || !nombre_completo) {
      return new Response(JSON.stringify({ error: "DNI, clave y nombre_completo son requeridos" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const email = `${dni}@incasur.app`;

    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password: clave,
      email_confirm: true,
      user_metadata: { dni, rol: "cliente" },
    });
    if (authError) {
      if (authError.message.includes("already exists")) {
        return new Response(JSON.stringify({ error: "El DNI ya está registrado" }), {
          status: 409,
          headers: { "Content-Type": "application/json" },
        });
      }
      throw new Error(authError.message);
    }

    const userId = authData.user.id;

    const { error: fichaError } = await supabaseAdmin.from("clientes_ficha").insert({
      usuario_id: userId,
      nombre_completo,
      telefono: telefono || "",
      negocio_nombre: negocio_nombre || "",
    });
    if (fichaError) throw new Error(fichaError.message);

    return new Response(JSON.stringify({ success: true, usuario_id: userId }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }
});
