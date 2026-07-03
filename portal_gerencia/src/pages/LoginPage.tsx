import React, { useState } from 'react'
import { useAuth } from '../auth/AuthContext'
import { useNavigate } from 'react-router-dom'

export default function LoginPage() {
  const [dni, setDni] = useState('')
  const [clave, setClave] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await login(dni, clave)
      navigate('/')
    } catch {
      setError('Credenciales inválidas')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="relative min-h-screen flex items-center justify-center p-4 overflow-hidden">
      {/* Background image with overlay */}
      <div
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: "url('/bg-login.png')" }}
      />
      <div className="absolute inset-0 bg-gradient-to-br from-incasur-azul/85 via-incasur-azuloscuro/70 to-black/80" />

      {/* Decorative elements */}
      <div className="absolute top-0 left-0 w-96 h-96 bg-incasur-amarillo/10 rounded-full -translate-x-1/2 -translate-y-1/2 blur-3xl" />
      <div className="absolute bottom-0 right-0 w-96 h-96 bg-incasur-azul/30 rounded-full translate-x-1/2 translate-y-1/2 blur-3xl" />

      {/* Login card */}
      <div className="relative w-full max-w-md">
        <div className="backdrop-blur-xl bg-white/10 rounded-3xl shadow-[0_8px_32px_rgba(0,0,0,0.4)] p-10 border border-white/20">
          {/* Logo & Title */}
          <div className="text-center mb-10">
            <div className="mx-auto mb-5 w-28 h-28 flex items-center justify-center">
              <img src="/logo.png" alt="CRAC Incasur" className="w-full h-full object-contain drop-shadow-lg" />
            </div>
            <h1 className="text-3xl font-bold text-white tracking-tight">CRAC Incasur</h1>
            <div className="w-12 h-0.5 bg-incasur-amarillo mx-auto mt-3 mb-3" />
            <p className="text-white/70 text-sm font-light tracking-widest uppercase">Portal de Gerencia</p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-5">
            <div>
              <label className="block text-sm font-medium text-white/80 mb-1.5">DNI</label>
              <input
                type="text"
                maxLength={8}
                value={dni}
                onChange={e => setDni(e.target.value.replace(/\D/g, '').slice(0, 8))}
                className="w-full px-4 py-3.5 bg-white/10 border border-white/20 rounded-xl text-white placeholder-white/40 focus:outline-none focus:ring-2 focus:ring-incasur-amarillo focus:border-transparent transition-all duration-300"
                placeholder="12345678"
                required
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-white/80 mb-1.5">Contraseña</label>
              <input
                type="password"
                value={clave}
                onChange={e => setClave(e.target.value)}
                className="w-full px-4 py-3.5 bg-white/10 border border-white/20 rounded-xl text-white placeholder-white/40 focus:outline-none focus:ring-2 focus:ring-incasur-amarillo focus:border-transparent transition-all duration-300"
                placeholder="••••••"
                required
              />
            </div>

            {error && (
              <div className="bg-red-500/20 border border-red-400/30 text-red-200 p-3.5 rounded-xl text-sm text-center backdrop-blur-sm">
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-incasur-azul text-white py-3.5 rounded-xl font-semibold text-base hover:bg-incasur-azuloscuro focus:outline-none focus:ring-2 focus:ring-incasur-amarillo/50 transition-all duration-300 disabled:opacity-50 shadow-lg shadow-incasur-azul/30"
            >
              {loading ? (
                <span className="flex items-center justify-center gap-2">
                  <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                  </svg>
                  Ingresando...
                </span>
              ) : 'Ingresar'}
            </button>
          </form>

          {/* Footer */}
          <p className="text-white/30 text-xs text-center mt-8 font-light">
            &copy; {new Date().getFullYear()} CRAC Incasur &mdash; Todos los derechos reservados
          </p>
        </div>
      </div>
    </div>
  )
}
