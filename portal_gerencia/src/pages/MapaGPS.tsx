import React, { useEffect, useState } from 'react'
import { MapPin, Navigation, Clock, User, RefreshCw } from 'lucide-react'
import { getCartera, CarteraItem } from '../services/api'

const prioridadColor: Record<string, string> = {
  ALTA: 'text-red-600 bg-red-50 border-red-200',
  MEDIA: 'text-orange-600 bg-orange-50 border-orange-200',
}

const gestionColor: Record<string, string> = {
  RENOVACION: 'border-blue-400',
  NUEVA_SOLICITUD: 'border-orange-400',
  RECUPERACION_MORA: 'border-red-400',
}

export default function MapaGPS() {
  const [visitas, setVisitas] = useState<CarteraItem[]>([])
  const [selectedMarker, setSelectedMarker] = useState<CarteraItem | null>(null)
  const [ultimaActualizacion, setUltimaActualizacion] = useState(new Date())

  const cargarDatos = () => {
    getCartera().then(setVisitas)
    setUltimaActualizacion(new Date())
  }

  useEffect(() => { cargarDatos() }, [])

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <MapPin className="text-incasur-verde" size={28} />
          <h1 className="text-2xl font-bold text-incasur-azul">Monitor de Control Geográfico</h1>
        </div>
        <button onClick={cargarDatos}
          className="flex items-center gap-1 text-sm text-gray-500 hover:text-incasur-azul">
          <RefreshCw size={14} />
          Actualizar
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        <div className="lg:col-span-3 bg-white rounded-xl shadow-sm border">
          <div className="relative h-[500px] bg-gray-100 rounded-lg overflow-hidden">
            <div className="absolute inset-0 p-4">
              <div className="bg-white/90 rounded-lg p-4 shadow-sm border max-w-xs">
                <p className="text-xs text-gray-500 mb-2">
                  Última actualización: {ultimaActualizacion.toLocaleTimeString()}
                </p>
                <div className="flex items-center gap-2 text-sm">
                  <Navigation size={16} className="text-incasur-verde" />
                  <span>{visitas.filter(v => v.visitado).length} visitas registradas</span>
                </div>
                <div className="flex items-center gap-2 text-sm mt-1">
                  <Clock size={16} className="text-gray-400" />
                  <span>{visitas.filter(v => !v.visitado).length} pendientes</span>
                </div>
              </div>

              <div className="absolute bottom-4 left-4 right-4 grid grid-cols-1 gap-2">
                {visitas.filter(v => v.ubicacion_lat).slice(0, 2).map(v => (
                  <button key={v.id} onClick={() => setSelectedMarker(v)}
                    className="bg-white p-2 rounded border shadow-sm text-left text-xs hover:bg-gray-50">
                    <div className="flex items-center gap-1">
                      <div className={`w-2 h-2 rounded-full ${v.visitado ? 'bg-green-500' : 'bg-yellow-500'}`} />
                      <span className="font-medium">{v.cliente}</span>
                    </div>
                    <p className="text-gray-400 ml-3">{v.negocio} — {v.tipo_gestion}</p>
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>

        <div className="space-y-4">
          <div className="bg-white rounded-xl shadow-sm border p-4">
            <h3 className="font-semibold text-sm mb-3">Rutas de Asesores</h3>
            <div className="space-y-3">
              {visitas.map(v => (
                <button key={v.id} onClick={() => setSelectedMarker(v)}
                  className={`w-full text-left p-3 rounded-lg border-l-4 text-xs transition-colors ${
                    gestionColor[v.tipo_gestion] || 'border-gray-300'
                  } ${selectedMarker?.id === v.id ? 'bg-blue-50' : 'hover:bg-gray-50'}`}>
                  <div className="flex justify-between items-start">
                    <div>
                      <p className="font-medium text-sm">{v.cliente}</p>
                      <p className="text-gray-500">{v.negocio}</p>
                    </div>
                    <span className={`text-[10px] px-1.5 py-0.5 rounded border ${
                      prioridadColor[v.prioridad] || 'text-gray-500'
                    }`}>
                      {v.prioridad}
                    </span>
                  </div>
                  <div className="flex justify-between mt-2 text-gray-400">
                    <span>{v.tipo_gestion.replace('_', ' ')}</span>
                    <span className={v.visitado ? 'text-green-500' : 'text-yellow-500'}>
                      {v.visitado ? '✓ Visitado' : '⊙ Pendiente'}
                    </span>
                  </div>
                  {v.ubicacion_lat && (
                    <p className="text-[10px] text-gray-300 mt-1">
                      {v.ubicacion_lat.toFixed(4)}, {v.ubicacion_lng?.toFixed(4)}
                    </p>
                  )}
                </button>
              ))}
            </div>
          </div>

          {selectedMarker && (
            <div className="bg-white rounded-xl shadow-sm border p-4">
              <h4 className="font-semibold text-sm">{selectedMarker.cliente}</h4>
              <p className="text-xs text-gray-500 mt-1">{selectedMarker.negocio}</p>
              <div className="mt-3 space-y-1 text-xs">
                <p><span className="text-gray-400">Gestión:</span> {selectedMarker.tipo_gestion}</p>
                <p><span className="text-gray-400">Prioridad:</span> {selectedMarker.prioridad}</p>
                <p><span className="text-gray-400">Teléfono:</span> {selectedMarker.telefono}</p>
                <p><span className="text-gray-400">Estado:</span> {selectedMarker.visitado ? 'Visitado' : 'Pendiente'}</p>
                {selectedMarker.ubicacion_lat && (
                  <p className="text-[10px] text-gray-300">
                    Lat: {selectedMarker.ubicacion_lat} / Lng: {selectedMarker.ubicacion_lng}
                  </p>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
