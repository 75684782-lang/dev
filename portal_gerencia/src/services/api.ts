import { supabase, edgeFunctionBase } from '../lib/supabase'

export interface Documento {
  tipo_documento: string
  storage_url: string
}

export interface Solicitud {
  id?: string
  numero_expediente: string
  cliente: string
  monto: number
  plazo_meses?: number
  tea?: number
  estado: string
  motivo_rechazo?: string
  telefono?: string
  negocio?: string
  con_desgravamen?: boolean
  creado_en?: string
  monto_aprobado?: number
  documentos?: Documento[]
  linea_tiempo?: { label: string; icono: string; activo: boolean }[]
}

export interface Desembolsable {
  id: string
  numero_expediente: string
  cliente: string
  telefono: string
  negocio: string
  monto: number
  plazo_meses: number
  tea: number
  con_desgravamen: boolean
  estado: string
}

export interface CarteraItem {
  id: string
  cliente: string
  tipo_gestion: string
  prioridad: string
  visitado: boolean
  telefono: string
  negocio: string
  ubicacion_lat?: number
  ubicacion_lng?: number
}

export interface Estadisticas {
  total_solicitudes: number
  total_colocado: number
  aprobados: number
  rechazados: number
  tasa_aprobacion: number
  monto_promedio: number
  distribucion_estados: Record<string, number>
}

export const getSolicitudes = async (): Promise<Solicitud[]> => {
  const { data } = await supabase
    .from('solicitudes_credito')
    .select('*, clientes_ficha!inner(nombre_completo)')
    .order('creado_en', { ascending: false })

  return (data || []).map((row: any) => ({
    id: row.id,
    numero_expediente: row.numero_expediente,
    cliente: row.clientes_ficha?.nombre_completo || '',
    monto: row.monto_solicitado,
    plazo_meses: row.plazo_meses,
    tea: row.tea,
    estado: row.estado,
    telefono: row.clientes_ficha?.telefono || '',
    negocio: row.clientes_ficha?.negocio_nombre || '',
    con_desgravamen: row.con_desgravamen,
    creado_en: row.creado_en,
  }))
}

export const getSolicitud = async (expediente: string) => {
  const { data } = await supabase
    .from('solicitudes_credito')
    .select('*, clientes_ficha!inner(nombre_completo, telefono, negocio_nombre)')
    .eq('numero_expediente', expediente)
    .single()

  if (!data) return null

  const { data: docs } = await supabase
    .from('solicitudes_documentos')
    .select('tipo_documento, storage_url')
    .eq('solicitud_id', (data as any).id)

  const estados = [
    { estado: 'enviado', label: 'Recibido', icono: '📩', orden: 0 },
    { estado: 'recibido_comite', label: 'En Comité', icono: '📋', orden: 1 },
    { estado: 'en_evaluacion', label: 'En Evaluación', icono: '🔍', orden: 2 },
    { estado: 'aprobado', label: 'Aprobado', icono: '✅', orden: 3 },
    { estado: 'condicionado', label: 'Condicionado', icono: '⚠️', orden: 3 },
    { estado: 'rechazado', label: 'Rechazado', icono: '❌', orden: 3 },
    { estado: 'desembolsado', label: 'Desembolsado', icono: '💰', orden: 4 },
  ]

  const ordenActual = estados.find(e => e.estado === data.estado)?.orden ?? 0

  return {
    ...data,
    cliente: (data as any).clientes_ficha?.nombre_completo || '',
    monto_solicitado: data.monto_solicitado,
    monto_aprobado: data.monto_aprobado,
    documentos: docs || [],
    firma_cliente_base64: (data as any).firma_cliente_base64 || null,
    linea_tiempo: estados.map(e => ({ ...e, activo: e.orden <= ordenActual })),
  }
}

export const getDesembolsables = async (): Promise<Desembolsable[]> => {
  const { data } = await supabase
    .from('solicitudes_credito')
    .select('*, clientes_ficha!inner(nombre_completo, telefono, negocio_nombre)')
    .in('estado', ['aprobado', 'condicionado'])
    .order('creado_en', { ascending: false })

  return (data || []).map((row: any) => ({
    id: row.id,
    numero_expediente: row.numero_expediente,
    cliente: row.clientes_ficha?.nombre_completo || '',
    telefono: row.clientes_ficha?.telefono || '',
    negocio: row.clientes_ficha?.negocio_nombre || '',
    monto: row.monto_solicitado,
    plazo_meses: row.plazo_meses,
    tea: row.tea,
    con_desgravamen: row.con_desgravamen,
    estado: row.estado,
  }))
}

export const getEstadisticas = async (): Promise<Estadisticas> => {
  const { data } = await supabase
    .from('solicitudes_credito')
    .select('monto_solicitado, estado, plazo_meses, creado_en')

  const rows = data || []
  const total = rows.length
  const totalColocado = rows
    .filter((r: any) => r.estado === 'desembolsado')
    .reduce((sum: number, r: any) => sum + Number(r.monto_solicitado), 0)
  const aprobados = rows.filter((r: any) => ['aprobado', 'desembolsado'].includes(r.estado)).length
  const rechazados = rows.filter((r: any) => r.estado === 'rechazado').length

  const distribucion: Record<string, number> = {}
  rows.forEach((r: any) => {
    distribucion[r.estado] = (distribucion[r.estado] || 0) + 1
  })

  return {
    total_solicitudes: total,
    total_colocado: totalColocado,
    aprobados,
    rechazados,
    tasa_aprobacion: total > 0 ? Math.round((aprobados / total) * 1000) / 10 : 0,
    monto_promedio: total > 0 ? Math.round((rows.reduce((s: number, r: any) => s + Number(r.monto_solicitado), 0) / total) * 100) / 100 : 0,
    distribucion_estados: distribucion,
  }
}

export const getCartera = async (): Promise<CarteraItem[]> => {
  const { data } = await supabase
    .from('cartera_diaria')
    .select('*, clientes_ficha!inner(id, nombre_completo, telefono, negocio_nombre)')
    .order('prioridad', { ascending: true })

  return (data || []).map((row: any) => ({
    id: row.id,
    cliente: row.clientes_ficha?.nombre_completo || '',
    tipo_gestion: row.tipo_gestion,
    prioridad: row.prioridad,
    visitado: row.visitado,
    telefono: row.clientes_ficha?.telefono || '',
    negocio: row.clientes_ficha?.negocio_nombre || '',
  }))
}

export const getCronograma = async (expediente: string) => {
  const { data: sol } = await supabase
    .from('solicitudes_credito')
    .select('id')
    .eq('numero_expediente', expediente)
    .single()

  if (!sol) return { expediente, data: [] }

  const { data: cuotas } = await supabase
    .from('cronogramas')
    .select('*')
    .eq('solicitud_id', sol.id)
    .order('numero_cuota')

  return {
    expediente,
    data: (cuotas || []).map((r: any) => ({
      cuota: r.numero_cuota,
      fecha: r.fecha_pago,
      monto: r.monto_cuota,
      capital: r.capital,
      interes: r.interes,
      saldo: r.saldo_pendiente,
    })),
  }
}

function calcularCronograma(monto: number, plazo: number, tea: number, fechaDesembolso: Date) {
  const TEM = Math.pow(1 + tea / 100, 1 / 12) - 1
  const cuotaFija = monto * (TEM * Math.pow(1 + TEM, plazo)) / (Math.pow(1 + TEM, plazo) - 1)
  let saldo = monto
  let totalIntereses = 0
  const cronograma: any[] = []
  const diaPago = fechaDesembolso.getDate()

  for (let i = 1; i <= plazo; i++) {
    const fecha = new Date(fechaDesembolso)
    fecha.setMonth(fecha.getMonth() + i)
    if (fecha.getDate() !== diaPago) {
      fecha.setDate(0)
    }

    const interes = saldo * TEM
    let capital = cuotaFija - interes
    if (i === plazo) {
      capital = saldo
    }
    const montoCuota = capital + interes
    saldo -= capital
    totalIntereses += interes

    cronograma.push({
      numero: i,
      fecha_pago: fecha.toISOString().split('T')[0],
      monto_cuota: Math.round(montoCuota * 100) / 100,
      capital: Math.round(capital * 100) / 100,
      interes: Math.round(interes * 100) / 100,
      saldo_pendiente: Math.round(Math.max(saldo, 0) * 100) / 100,
    })
  }

  return {
    tea,
    tem: Math.round(TEM * 100000000) / 100000000,
    cuota_fija: Math.round(cuotaFija * 100) / 100,
    total_intereses: Math.round(totalIntereses * 100) / 100,
    total_pagar: Math.round((monto + totalIntereses) * 100) / 100,
    cronograma,
  }
}

export const actualizarEstadoSolicitud = async (expediente: string, estado: string, motivo?: string) => {
  const payload: Record<string, any> = { estado }
  if (motivo) payload.motivo_rechazo = motivo
  await supabase.from('solicitudes_credito').update(payload).eq('numero_expediente', expediente)
}

export const desembolsarSolicitud = async (expediente: string, fechaDesembolso?: string) => {
  const { data: sol } = await supabase
    .from('solicitudes_credito')
    .select('*')
    .eq('numero_expediente', expediente)
    .single()

  if (!sol) throw new Error('Solicitud no encontrada')

  const monto = Number(sol.monto_solicitado)
  const fecha = fechaDesembolso ? new Date(fechaDesembolso) : new Date()
  const TEA = sol.con_desgravamen ? 40.92 : 43.92

  const result = calcularCronograma(monto, sol.plazo_meses, TEA, fecha)

  await supabase.from('solicitudes_credito').update({
    estado: 'desembolsado',
  }).eq('id', sol.id)

  for (const cuota of result.cronograma) {
    await supabase.from('cronogramas').insert({
      solicitud_id: sol.id,
      numero_cuota: cuota.numero,
      fecha_pago: cuota.fecha_pago,
      monto_cuota: cuota.monto_cuota,
      capital: cuota.capital,
      interes: cuota.interes,
      saldo_pendiente: cuota.saldo_pendiente,
    })
  }

  return {
    expediente,
    estado: 'desembolsado',
    cronograma_generado: true,
    mensaje: `Crédito ${expediente} desembolsado. ${result.cronograma.length} cuotas generadas.`,
  }
}

export const condicionarSolicitud = async (expediente: string, montoModificado: number, plazoModificado: number, motivo: string) => {
  await supabase.from('solicitudes_credito').update({
    estado: 'condicionado',
    monto_solicitado: montoModificado,
    plazo_meses: plazoModificado,
    motivo_rechazo: motivo,
  }).eq('numero_expediente', expediente)
}

export const recibirEnComite = async (expediente: string) => {
  await supabase.from('solicitudes_credito').update({ estado: 'recibido_comite' })
    .eq('numero_expediente', expediente)
}

export const promoverEvaluacion = async (expediente: string) => {
  await supabase.from('solicitudes_credito').update({ estado: 'en_evaluacion' })
    .eq('numero_expediente', expediente)
}
