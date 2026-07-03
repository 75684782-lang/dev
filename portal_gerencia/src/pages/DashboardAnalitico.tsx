import React, { useEffect, useState } from 'react'
import { BarChart3, TrendingUp, Users, DollarSign, Target } from 'lucide-react'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell, LineChart, Line } from 'recharts'
import { getEstadisticas, Estadisticas } from '../services/api'

const COLORS = { aprobado: '#2E7D32', rechazado: '#C62828', condicionado: '#FF6D00', enviado: '#2196F3', en_evaluacion: '#1565C0', desembolsado: '#7B1FA2', borrador: '#9E9E9E' }

const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']

export default function DashboardAnalitico() {
  const [stats, setStats] = useState<Estadisticas | null>(null)
  const [cargando, setCargando] = useState(true)

  useEffect(() => {
    getEstadisticas().then(data => {
      setStats(data)
      setCargando(false)
    }).catch(() => setCargando(false))
  }, [])

  if (cargando) return <div className="p-6 text-center text-gray-400">Cargando dashboard...</div>
  if (!stats) return <div className="p-6 text-center text-gray-400">No hay datos disponibles</div>

  const dist = stats.distribucion_estados || {}
  const datosPie = Object.entries(dist).map(([name, value]) => ({
    name: name.replace('_', ' '),
    value,
    color: COLORS[name as keyof typeof COLORS] || '#9E9E9E',
  }))

  const month = new Date().getMonth()
  const datosBar = Array.from({ length: 6 }, (_, i) => ({
    mes: meses[(month - 5 + i + 12) % 12],
    casos: Math.round(stats.total_solicitudes / 6),
  }))

  const datosMonto = Array.from({ length: 6 }, (_, i) => ({
    mes: meses[(month - 5 + i + 12) % 12],
    monto: Math.round(stats.total_colocado / 6),
  }))

  return (
    <div className="p-6">
      <div className="flex items-center gap-3 mb-6">
        <BarChart3 className="text-incasur-verde" size={28} />
        <h1 className="text-2xl font-bold text-incasur-azul">Dashboard Analítico</h1>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        {[
          { label: 'Total Colocado', value: `S/ ${stats.total_colocado.toLocaleString()}`, icon: DollarSign, color: 'bg-green-100 text-green-600' },
          { label: 'Casos Aprobados', value: stats.aprobados.toString(), icon: TrendingUp, color: 'bg-blue-100 text-blue-600' },
          { label: 'Tasa de Aprobación', value: `${stats.tasa_aprobacion}%`, icon: Target, color: 'bg-purple-100 text-purple-600' },
          { label: 'Total Solicitudes', value: stats.total_solicitudes.toString(), icon: Users, color: 'bg-orange-100 text-orange-600' },
        ].map(({ label, value, icon: Icon, color }) => (
          <div key={label} className="bg-white rounded-xl shadow-sm border p-5">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-500">{label}</p>
                <p className="text-2xl font-bold text-incasur-azul mt-1">{value}</p>
              </div>
              <div className={`p-3 rounded-lg ${color}`}>
                <Icon size={24} />
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        <div className="bg-white rounded-xl shadow-sm border p-6">
          <h3 className="font-semibold mb-4">Distribución de Casos</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={datosBar}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="mes" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="casos" fill="#2E7D32" name="Casos" radius={[4,4,0,0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-white rounded-xl shadow-sm border p-6">
          <h3 className="font-semibold mb-4">Distribución por Estados</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie data={datosPie} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={100}
                label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}>
                {datosPie.map((entry, i) => (
                  <Cell key={i} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="bg-white rounded-xl shadow-sm border p-6">
          <h3 className="font-semibold mb-4">Monto Promedio</h3>
          <p className="text-3xl font-bold text-incasur-verde">S/ {stats.monto_promedio.toLocaleString()}</p>
          <p className="text-sm text-gray-500 mt-2">Monto promedio por solicitud</p>
        </div>

        <div className="bg-white rounded-xl shadow-sm border p-6 lg:col-span-2">
          <h3 className="font-semibold mb-4">Indicadores Clave</h3>
          <div className="grid grid-cols-2 gap-4">
            {[
              { label: 'Monto Promedio por Crédito', value: `S/ ${stats.monto_promedio.toLocaleString()}`, trend: 'up' as const },
              { label: 'Tasa de Aprobación', value: `${stats.tasa_aprobacion}%`, trend: stats.tasa_aprobacion > 50 ? 'up' as const : 'down' as const },
              { label: 'Total Colocado', value: `S/ ${stats.total_colocado.toLocaleString()}`, trend: 'up' as const },
              { label: 'Solicitudes Totales', value: stats.total_solicitudes.toString(), trend: 'up' as const },
              { label: 'Aprobados', value: stats.aprobados.toString(), trend: 'up' as const },
              { label: 'Rechazados', value: stats.rechazados.toString(), trend: 'down' as const },
            ].map(({ label, value, trend }) => (
              <div key={label} className="p-3 rounded-lg bg-gray-50 border">
                <p className="text-xs text-gray-500">{label}</p>
                <div className="flex items-center gap-2 mt-1">
                  <p className="text-lg font-bold text-incasur-azul">{value}</p>
                  <span className={`text-xs ${trend === 'up' ? 'text-green-500' : 'text-blue-500'}`}>
                    {trend === 'up' ? '↑' : '↓'}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
