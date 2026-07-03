import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

interface SimularRequest {
  monto: number;
  plazo_meses: number;
  con_desgravamen: boolean;
}

interface Cuota {
  numero: number;
  fecha_pago: string;
  monto_cuota: number;
  capital: number;
  interes: number;
  saldo_pendiente: number;
}

interface SimularResponse {
  tea: number;
  tem: number;
  cuota_fija: number;
  total_intereses: number;
  total_pagar: number;
  cronograma: Cuota[];
}

function calcularCronograma(monto: number, plazo: number, tea: number): SimularResponse {
  const TEM = Math.pow(1 + tea / 100, 1 / 12) - 1;
  let cuotaFija = monto * (TEM * Math.pow(1 + TEM, plazo)) / (Math.pow(1 + TEM, plazo) - 1);
  let saldo = monto;
  let totalIntereses = 0;
  const cronograma: Cuota[] = [];
  const today = new Date();

  for (let i = 1; i <= plazo; i++) {
    const fecha = new Date(today.getFullYear(), today.getMonth() + i, 1);
    const interes = saldo * TEM;
    let capital = cuotaFija - interes;
    if (i === plazo) {
      capital = saldo;
      cuotaFija = capital + interes;
    }
    saldo -= capital;
    totalIntereses += interes;
    cronograma.push({
      numero: i,
      fecha_pago: fecha.toISOString().split("T")[0],
      monto_cuota: Math.round(cuotaFija * 100) / 100,
      capital: Math.round(capital * 100) / 100,
      interes: Math.round(interes * 100) / 100,
      saldo_pendiente: Math.round(Math.max(saldo, 0) * 100) / 100,
    });
  }

  return {
    tea,
    tem: Math.round(TEM * 100000000) / 100000000,
    cuota_fija: Math.round(cuotaFija * 100) / 100,
    total_intereses: Math.round(totalIntereses * 100) / 100,
    total_pagar: Math.round((monto + totalIntereses) * 100) / 100,
    cronograma,
  };
}

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const body: SimularRequest = await req.json();
    const TEA = body.con_desgravamen ? 40.92 : 43.92;
    const result = calcularCronograma(body.monto, body.plazo_meses, TEA);

    return new Response(JSON.stringify(result), {
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
