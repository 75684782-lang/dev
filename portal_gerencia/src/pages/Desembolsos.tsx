import React, { useEffect, useState } from 'react'
import { CreditCard, Send, CheckCircle, FileText, Download, RefreshCw } from 'lucide-react'
import { getDesembolsables, desembolsarSolicitud, getCronograma, Desembolsable } from '../services/api'

export default function Desembolsos() {
  const [solicitudes, setSolicitudes] = useState<Desembolsable[]>([])
  const [desembolsando, setDesembolsando] = useState<string | null>(null)
  const [cronogramas, setCronogramas] = useState<Record<string, any>>({})
  const [cargando, setCargando] = useState(false)

  const cargarDatos = () => {
    getDesembolsables().then(setSolicitudes)
  }

  useEffect(() => { cargarDatos() }, [])

  const handleDesembolsar = async (expediente: string) => {
    setDesembolsando(expediente)
    try {
      const hoy = new Date().toISOString().split('T')[0]
      const res = await desembolsarSolicitud(expediente, hoy)
      const crono = await getCronograma(expediente)
      setCronogramas(prev => ({ ...prev, [expediente]: crono }))
      cargarDatos()
    } catch (e) { console.error(e) }
    setDesembolsando(null)
  }

  const totalColocado = solicitudes
    .filter(s => s.estado === 'desembolsado')
    .reduce((acc, s) => acc + s.monto, 0)

  const aprobadas = solicitudes.filter(s => s.estado === 'aprobado')
  const desembolsadas = solicitudes.filter(s => s.estado === 'desembolsado')

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <CreditCard className="text-incasur-verde" size={28} />
          <h1 className="text-2xl font-bold text-incasur-azul">Control de Desembolsos</h1>
        </div>
        <button onClick={cargarDatos} className="flex items-center gap-1 text-sm text-gray-500 hover:text-incasur-azul">
          <RefreshCw size={14} /> Actualizar
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        {[
          { label: 'Aprobadas', value: aprobadas.length.toString(), color: 'text-green-600' },
          { label: 'Desembolsadas', value: desembolsadas.length.toString(), color: 'text-purple-600' },
          { label: 'Total Colocado', value: `S/ ${totalColocado.toLocaleString()}`, color: 'text-incasur-verde' },
          { label: 'Pendientes', value: aprobadas.length.toString(), color: 'text-orange-600' },
        ].map(({ label, value, color }) => (
          <div key={label} className="bg-white rounded-xl shadow-sm border p-4">
            <p className="text-xs text-gray-500">{label}</p>
            <p className={`text-xl font-bold mt-1 ${color}`}>{value}</p>
          </div>
        ))}
      </div>

      <div className="bg-white rounded-xl shadow-sm border">
        <div className="p-4 border-b">
          <h2 className="font-semibold">Solicitudes Aprobadas — Pendientes de Desembolso</h2>
        </div>
        <div className="divide-y">
          {solicitudes.length === 0 && (
            <div className="p-8 text-center text-gray-400">No hay solicitudes aprobadas pendientes de desembolso</div>
          )}
          {solicitudes.map(s => {
            const crono = cronogramas[s.numero_expediente]
            return (
              <div key={s.numero_expediente} className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <div className="flex items-center gap-2">
                      <p className="font-medium">{s.numero_expediente}</p>
                      <span className={`text-xs px-2 py-0.5 rounded-full ${
                        s.estado === 'desembolsado' ? 'bg-purple-100 text-purple-700' : 'bg-green-100 text-green-700'
                      }`}>
                        {s.estado === 'desembolsado' ? 'Desembolsado' : 'Aprobado'}
                      </span>
                    </div>
                    <p className="text-sm text-gray-600">{s.cliente}</p>
                    <div className="flex gap-4 mt-1 text-xs text-gray-400">
                      <span>S/ {s.monto.toLocaleString()}</span>
                      <span>{s.plazo_meses} meses</span>
                      <span>TEA {s.tea}%</span>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    {s.estado === 'desembolsado' ? (
                      <div className="flex gap-2">
                        <span className="flex items-center gap-1 text-green-600 text-sm font-medium">
                          <CheckCircle size={16} /> Desembolsado
                        </span>
                      </div>
                    ) : (
                      <button
                        onClick={() => handleDesembolsar(s.numero_expediente)}
                        disabled={desembolsando === s.numero_expediente}
                        className="flex items-center gap-2 bg-incasur-azul text-white px-5 py-2 rounded-lg hover:bg-blue-900 transition-colors text-sm disabled:opacity-50"
                      >
                        {desembolsando === s.numero_expediente ? (
                          <>Procesando...</>
                        ) : (
                          <><Send size={16} /> Ejecutar Desembolso</>
                        )}
                      </button>
                    )}
                  </div>
                </div>

                {crono && crono.data && (
                  <div className="mt-3 bg-purple-50 border border-purple-200 rounded-lg p-3">
                    <div className="flex items-center gap-2 text-sm text-purple-800">
                      <FileText size={16} />
                      <span>Cronograma generado — {crono.data.length} cuotas</span>
                    </div>
                    <div className="mt-2 flex gap-2 flex-wrap">
                      {crono.data.slice(0, 6).map((c: any) => (
                        <div key={c.cuota} className="text-[10px] bg-white px-2 py-1 rounded border">
                          #{c.cuota}: S/ {c.monto.toFixed(2)}
                        </div>
                      ))}
                      {crono.data.length > 6 && <span className="text-[10px] text-purple-400 self-center">...</span>}
                    </div>
                  </div>
                )}
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
