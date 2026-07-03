import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const { codigo_empleado } = await req.json();
    if (!codigo_empleado) {
      return new Response(JSON.stringify({ error: "codigo_empleado requerido" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const resp = await fetch(`${supabaseUrl}/auth/v1/admin/users`, {
      headers: {
        Authorization: `Bearer ${serviceRoleKey}`,
        apikey: serviceRoleKey,
      },
    });

    if (!resp.ok) {
      throw new Error("Error al consultar usuarios");
    }

    const { users } = await resp.json();
    const user = users.find(
      (u: any) => u.user_metadata?.codigo_empleado === codigo_empleado
    );

    if (!user) {
      return new Response(JSON.stringify({ error: "Código de empleado inválido" }), {
        status: 401,
        headers: { "Content-Type": "application/json" },
      });
    }

    // Add codigo_empleado to metadata if not present (for legacy users)
    if (!user.user_metadata?.codigo_empleado) {
      await fetch(`${supabaseUrl}/auth/v1/admin/users/${user.id}`, {
        method: "PUT",
        headers: {
          Authorization: `Bearer ${serviceRoleKey}`,
          apikey: serviceRoleKey,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          user_metadata: {
            ...user.user_metadata,
            codigo_empleado,
          },
        }),
      });
    }

    return new Response(JSON.stringify({
      dni: user.user_metadata.dni,
      asesor_id: user.id,
      nombres: user.user_metadata.nombres || codigo_empleado,
      apellidos: "",
      perfil: user.user_metadata.rol || "operador",
    }), {
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
