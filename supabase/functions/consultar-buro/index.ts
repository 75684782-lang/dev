import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const SBS_MAP: Record<string, {
  calificacion: string;
  entidades: number;
  deuda_total: number;
  dias_mora: number;
  inhabilitado: boolean;
}> = {
  "0": { calificacion: "NORMAL", entidades: 1, deuda_total: 4500, dias_mora: 0, inhabilitado: false },
  "1": { calificacion: "NORMAL", entidades: 2, deuda_total: 12000, dias_mora: 0, inhabilitado: false },
  "2": { calificacion: "CPP", entidades: 2, deuda_total: 18000, dias_mora: 15, inhabilitado: false },
  "3": { calificacion: "NORMAL", entidades: 0, deuda_total: 0, dias_mora: 0, inhabilitado: false },
  "4": { calificacion: "DUDOSO", entidades: 3, deuda_total: 25000, dias_mora: 95, inhabilitado: false },
  "5": { calificacion: "DEFICIENTE", entidades: 2, deuda_total: 16000, dias_mora: 45, inhabilitado: false },
  "6": { calificacion: "NORMAL", entidades: 1, deuda_total: 6000, dias_mora: 0, inhabilitado: false },
  "7": { calificacion: "PERDIDA", entidades: 4, deuda_total: 40000, dias_mora: 210, inhabilitado: true },
  "8": { calificacion: "CPP", entidades: 1, deuda_total: 9000, dias_mora: 20, inhabilitado: false },
  "9": { calificacion: "NORMAL", entidades: 2, deuda_total: 14000, dias_mora: 0, inhabilitado: false },
};

serve(async (req) => {
  if (req.method !== "GET") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const url = new URL(req.url);
    const dni = url.pathname.split("/").pop() || "";

    if (dni.length !== 8 || !/^\d{8}$/.test(dni)) {
      return new Response(JSON.stringify({ error: "DNI debe tener 8 dígitos" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const ultimo = dni.charAt(dni.length - 1);
    const perfil = SBS_MAP[ultimo] || SBS_MAP["0"];

    return new Response(
      JSON.stringify({
        dni,
        calificacion: perfil.calificacion,
        entidades_con_deuda: perfil.entidades,
        deuda_total: perfil.deuda_total,
        dias_mayor_mora: perfil.dias_mora,
        inhabilitado: perfil.inhabilitado,
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
