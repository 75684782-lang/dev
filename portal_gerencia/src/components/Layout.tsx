import React from 'react'
import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { MapPin, FileText, CreditCard, BarChart3, LogOut, User } from 'lucide-react'
import { useAuth } from '../auth/AuthContext'

const navItems = [
  { to: '/', icon: MapPin, label: 'Mapa GPS' },
  { to: '/comite', icon: FileText, label: 'Comité de Créditos' },
  { to: '/desembolsos', icon: CreditCard, label: 'Desembolsos' },
  { to: '/dashboard', icon: BarChart3, label: 'Dashboard' },
]

export default function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  return (
    <div className="flex h-screen bg-gray-50">
      <aside className="w-64 bg-incasur-azul text-white flex flex-col">
        <div className="p-6 border-b border-white/10 flex flex-col items-center">
          <img src="/logo.png" alt="CRAC Incasur" className="h-12 w-auto mb-2 drop-shadow-md" />
          <p className="text-sm text-white/60">Portal Gerencia</p>
        </div>

        {user && (
          <div className="px-4 py-3 border-b border-white/10 flex items-center gap-3">
            <div className="w-8 h-8 bg-incasur-dorado rounded-full flex items-center justify-center">
              <User size={16} />
            </div>
            <div className="text-sm">
              <p className="font-medium capitalize">{user.rol}</p>
              <p className="text-white/60 text-xs">{user.usuario_id.slice(0, 8)}</p>
            </div>
          </div>
        )}

        <nav className="flex-1 p-4 space-y-2">
          {navItems.map(({ to, icon: Icon, label }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) =>
                `flex items-center gap-3 px-4 py-3 rounded-lg text-sm transition-colors ${
                  isActive ? 'bg-white/15 text-white' : 'text-white/70 hover:bg-white/10 hover:text-white'
                }`
              }
            >
              <Icon size={20} />
              {label}
            </NavLink>
          ))}
        </nav>
        <div className="p-4 border-t border-white/10">
          <button
            onClick={handleLogout}
            className="flex items-center gap-3 text-white/70 hover:text-white text-sm w-full px-4 py-2 transition-colors"
          >
            <LogOut size={18} />
            Cerrar Sesión
          </button>
        </div>
      </aside>
      <main className="flex-1 overflow-auto">
        <Outlet />
      </main>
    </div>
  )
}
