import React, { useEffect, useState } from 'react'
import { FileText, CheckCircle, XCircle, AlertTriangle, DollarSign, Calendar, User } from 'lucide-react'
import { getSolicitudes, getSolicitud, actualizarEstadoSolicitud, condicionarSolicitud, recibirEnComite, promoverEvaluacion, Solicitud } from '../services/api'

const statusColors: Record<string, string> = {
  enviado: 'bg-yellow-100 text-yellow-800',
  recibido_comite: 'bg-indigo-100 text-indigo-800',
  en_evaluacion: 'bg-blue-100 text-blue-800',
  aprobado: 'bg-green-100 text-green-800',
  rechazado: 'bg-red-100 text-red-800',
  condicionado: 'bg-orange-100 text-orange-800',
  desembolsado: 'bg-purple-100 text-purple-800',
}

export default function ComiteCreditos() {
  const [solicitudes, setSolicitudes] = useState<Solicitud[]>([])
  const [selected, setSelected] = useState<Solicitud | null>(null)
  const [selectedDetail, setSelectedDetail] = useState<any>(null)
  const [motivoRechazo, setMotivoRechazo] = useState('')
  const [modoCondicionar, setModoCondicionar] = useState(false)
  const [montoModificado, setMontoModificado] = useState('')
  const [plazoModificado, setPlazoModificado] = useState('')
  const [filtro, setFiltro] = useState<string>('todos')
  const [cargando, setCargando] = useState(false)

  const cargarSolicitudes = () => {
    getSolicitudes().then(setSolicitudes)
  }

  useEffect(() => { cargarSolicitudes() }, [])

  useEffect(() => {
    if (selected) {
      getSolicitud(selected.numero_expediente).then(setSelectedDetail)
      setMontoModificado(selected.monto.toLocaleString())
      setPlazoModificado(selected.plazo_meses?.toString() || '12')
    }
  }, [selected])

  const handleAprobar = async () => {
    if (!selected) return
    setCargando(true)
    try {
      await actualizarEstadoSolicitud(selected.numero_expediente, 'aprobado')
      cargarSolicitudes()
      setSelected(null)
    } catch (e) { console.error(e) }
    setCargando(false)
  }

  const handleRechazar = async () => {
    if (!selected || !motivoRechazo.trim()) return
    setCargando(true)
    try {
      await actualizarEstadoSolicitud(selected.numero_expediente, 'rechazado', motivoRechazo)
      cargarSolicitudes()
      setSelected(null)
      setMotivoRechazo('')
    } catch (e) { console.error(e) }
    setCargando(false)
  }

  const handleCondicionar = async () => {
    if (!selected) return
    setCargando(true)
    try {
      await condicionarSolicitud(
        selected.numero_expediente,
        parseFloat(montoModificado.replace(/,/g, '')),
        parseInt(plazoModificado),
        'Aprobado con condiciones modificadas',
      )
      cargarSolicitudes()
      setSelected(null)
      setModoCondicionar(false)
    } catch (e) { console.error(e) }
    setCargando(false)
  }

  const enviarAComite = async (expediente: string) => {
    try {
      await recibirEnComite(expediente)
      cargarSolicitudes()
    } catch (e) { console.error(e) }
  }

  const enviarAEvaluacion = async (expediente: string) => {
    try {
      await promoverEvaluacion(expediente)
      cargarSolicitudes()
    } catch (e) { console.error(e) }
  }

  const filtradas = filtro === 'todos'
    ? solicitudes
    : solicitudes.filter(s => s.estado === filtro)

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <FileText className="text-incasur-verde" size={28} />
          <h1 className="text-2xl font-bold text-incasur-azul">Comité de Créditos</h1>
        </div>
        <span className="text-sm text-gray-500 bg-white px-3 py-1 rounded-full border">
          {solicitudes.filter(s => s.estado === 'en_evaluacion').length} en evaluación
        </span>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 bg-white rounded-xl shadow-sm border">
          <div className="p-4 border-b flex justify-between items-center">
            <h2 className="font-semibold">Bandeja de Solicitudes</h2>
            <div className="flex gap-2">
              {[['en_evaluacion', 'En Evaluación'], ['recibido_comite', 'En Comité'], ['enviado', 'Enviados'], ['aprobado', 'Aprobados'], ['todos', 'Todos']].map(([f, lbl]) => (
                <button key={f} onClick={() => setFiltro(f)}
                  className={`text-xs px-3 py-1 rounded-full ${filtro === f ? 'bg-incasur-azul text-white' : 'bg-gray-100 hover:bg-gray-200 text-gray-600'}`}>
                  {lbl}
                </button>
              ))}
            </div>
          </div>
          <div className="divide-y">
            {filtradas.map(s => (
              <button
                key={s.numero_expediente}
                onClick={() => setSelected(s)}
                className={`w-full text-left p-4 hover:bg-gray-50 transition-colors ${selected?.numero_expediente === s.numero_expediente ? 'bg-blue-50' : ''}`}
              >
                <div className="flex justify-between items-start">
                  <div>
                    <div className="flex items-center gap-2">
                      <p className="font-medium text-sm">{s.numero_expediente}</p>
                      {s.estado === 'en_evaluacion' && <span className="w-2 h-2 rounded-full bg-blue-500 animate-pulse" />}
                      {s.estado === 'enviado' && (
                        <button onClick={(e) => { e.stopPropagation(); enviarAComite(s.numero_expediente); }}
                          className="text-[10px] bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded hover:bg-indigo-200">
                          Enviar a Comité
                        </button>
                      )}
                      {s.estado === 'recibido_comite' && (
                        <button onClick={(e) => { e.stopPropagation(); enviarAEvaluacion(s.numero_expediente); }}
                          className="text-[10px] bg-blue-100 text-blue-700 px-2 py-0.5 rounded hover:bg-blue-200">
                          Iniciar Evaluación
                        </button>
                      )}
                    </div>
                    <p className="text-sm text-gray-600">{s.cliente}</p>
                    <div className="flex gap-3 mt-1">
                      <p className="text-xs text-gray-400">S/ {s.monto?.toLocaleString()}</p>
                      <p className="text-xs text-gray-400">{s.plazo_meses || 12} meses</p>
                    </div>
                  </div>
                  <span className={`px-2 py-1 rounded text-xs font-medium ${statusColors[s.estado] || 'bg-gray-100'}`}>
                    {s.estado?.replace('_', ' ')}
                  </span>
                </div>
              </button>
            ))}
          </div>
        </div>

        {selected && (
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h2 className="font-semibold mb-4 flex items-center gap-2">
              <FileText size={18} />
              Revisar Expediente
            </h2>

            <div className="space-y-3 text-sm">
              <div className="flex items-center gap-2">
                <User size={14} className="text-gray-400" />
                <div>
                  <p className="text-gray-500 text-xs">Cliente</p>
                  <p className="font-medium">{selectedDetail?.cliente || selected.cliente}</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <DollarSign size={14} className="text-gray-400" />
                <div>
                  <p className="text-gray-500 text-xs">Monto Solicitado</p>
                  <p className="font-medium text-lg text-incasur-verde">S/ {selected.monto?.toLocaleString()}</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <Calendar size={14} className="text-gray-400" />
                <div>
                  <p className="text-gray-500 text-xs">Plazo</p>
                  <p className="font-medium">{selected.plazo_meses || 12} meses</p>
                </div>
              </div>
              <div>
                <p className="text-gray-500 text-xs mb-1">Estado Actual</p>
                <span className={`inline-block px-2 py-1 rounded text-xs font-medium ${statusColors[selected.estado]}`}>
                  {selected.estado?.replace('_', ' ')}
                </span>
              </div>
              {selectedDetail?.tea && (
                <div>
                  <p className="text-gray-500 text-xs">TEA</p>
                  <p className="font-medium">{selectedDetail.tea}%</p>
                </div>
              )}
              {selectedDetail?.garantia && (
                <div>
                  <p className="text-gray-500 text-xs">Garantía</p>
                  <p className="font-medium">{selectedDetail.garantia}</p>
                </div>
              )}
              {selectedDetail?.destino_credito && (
                <div>
                  <p className="text-gray-500 text-xs">Destino</p>
                  <p className="font-medium">{selectedDetail.destino_credito}</p>
                </div>
              )}

              {selectedDetail?.documentos && selectedDetail.documentos.length > 0 && (
                <div className="border-t pt-4">
                  <p className="text-xs text-gray-500 mb-2">Documentos Adjuntos</p>
                  <div className="grid grid-cols-2 gap-2">
                    {selectedDetail.documentos.map((doc: any, i: number) => (
                      <a key={i} href={doc.storage_url} target="_blank" rel="noopener noreferrer"
                        className="block border rounded-lg overflow-hidden hover:ring-2 hover:ring-incasur-verde transition-all">
                        <img src={doc.storage_url} alt={doc.tipo_documento}
                          className="w-full h-24 object-cover bg-gray-100" />
                        <p className="text-[10px] text-center py-1 text-gray-500 bg-white">
                          {doc.tipo_documento.replace(/_/g, ' ')}
                        </p>
                      </a>
                    ))}
                  </div>
                </div>
              )}
              {selectedDetail?.firma_cliente_base64 && (
                <div className="border-t pt-4">
                  <p className="text-xs text-gray-500 mb-2">Firma del Cliente</p>
                  <img src={`data:image/png;base64,${selectedDetail.firma_cliente_base64}`} alt="Firma"
                    className="w-full max-h-20 object-contain bg-white border rounded p-2" />
                </div>
              )}
            </div>

            {selectedDetail?.linea_tiempo && (
              <div className="mt-4 border-t pt-4">
                <p className="text-xs text-gray-500 mb-2">Línea de Tiempo</p>
                <div className="flex justify-between">
                  {selectedDetail.linea_tiempo.map((item: any, i: number) => (
                    <div key={i} className="text-center">
                      <div className={`text-lg ${item.activo ? 'opacity-100' : 'opacity-30'}`}>{item.icono}</div>
                      <p className={`text-[10px] mt-1 ${item.activo ? 'text-incasur-azul font-medium' : 'text-gray-300'}`}>{item.label}</p>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {selected.estado === 'enviado' && (
              <div className="mt-6">
                <button onClick={() => enviarAComite(selected.numero_expediente)}
                  className="w-full bg-indigo-600 text-white py-2.5 rounded-lg hover:bg-indigo-700 transition-colors">
                  Recibir en Comité
                </button>
              </div>
            )}

            {selected.estado === 'recibido_comite' && (
              <div className="mt-6">
                <button onClick={() => enviarAEvaluacion(selected.numero_expediente)}
                  className="w-full bg-blue-600 text-white py-2.5 rounded-lg hover:bg-blue-700 transition-colors">
                  Iniciar Evaluación
                </button>
              </div>
            )}

            {(selected.estado === 'en_evaluacion') && (
              <div className="mt-6 space-y-3">
                <button onClick={handleAprobar} disabled={cargando}
                  className="w-full flex items-center justify-center gap-2 bg-green-600 text-white py-2.5 rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50">
                  <CheckCircle size={18} /> Aprobar
                </button>

                {!modoCondicionar ? (
                  <button onClick={() => setModoCondicionar(true)}
                    className="w-full flex items-center justify-center gap-2 bg-orange-500 text-white py-2.5 rounded-lg hover:bg-orange-600 transition-colors">
                    <AlertTriangle size={18} /> Condicionar
                  </button>
                ) : (
                  <div className="space-y-2 p-3 bg-orange-50 rounded-lg border border-orange-200">
                    <p className="text-xs font-medium text-orange-800">Modificar condiciones</p>
                    <input type="number" value={montoModificado}
                      onChange={e => setMontoModificado(e.target.value)}
                      className="w-full border rounded p-2 text-sm" placeholder="Nuevo monto" />
                    <input type="number" value={plazoModificado}
                      onChange={e => setPlazoModificado(e.target.value)}
                      className="w-full border rounded p-2 text-sm" placeholder="Nuevo plazo" />
                    <div className="flex gap-2">
                      <button onClick={handleCondicionar} disabled={cargando}
                        className="flex-1 bg-orange-600 text-white py-1.5 rounded text-sm hover:bg-orange-700 disabled:opacity-50">
                        Confirmar
                      </button>
                      <button onClick={() => setModoCondicionar(false)}
                        className="px-3 py-1.5 text-sm text-gray-500 hover:text-gray-700">
                        Cancelar
                      </button>
                    </div>
                  </div>
                )}

                <textarea placeholder="Motivo de rechazo..."
                  value={motivoRechazo}
                  onChange={e => setMotivoRechazo(e.target.value)}
                  className="w-full border rounded-lg p-3 text-sm" rows={2} />
                <button onClick={handleRechazar} disabled={!motivoRechazo.trim() || cargando}
                  className="w-full flex items-center justify-center gap-2 bg-red-600 text-white py-2.5 rounded-lg hover:bg-red-700 transition-colors disabled:opacity-50">
                  <XCircle size={18} /> Rechazar
                </button>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}
