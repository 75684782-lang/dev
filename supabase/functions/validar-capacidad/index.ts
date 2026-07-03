import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

interface CapacidadRequest {
  ingresos_mensuales: number;
  costos_mercaderia: number;
  gastos_familiares: number;
  cuota_simulada: number;
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const body: CapacidadRequest = await req.json();
    const excedente = body.ingresos_mensuales - body.costos_mercaderia - body.gastos_familiares;
    const cobertura = body.cuota_simulada > 0 ? (excedente / body.cuota_simulada) * 100 : 0;
    const suficiente = cobertura >= 130;

    return new Response(
      JSON.stringify({
        excedente_familiar: Math.round(excedente * 100) / 100,
        cobertura_porcentaje: Math.round(cobertura * 10) / 10,
        suficiente,
        mensaje: suficiente
          ? "Capacidad de pago suficiente"
          : "Capacidad de pago insuficiente - El excedente debe cubrir al menos el 130% de la cuota",
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }
});
