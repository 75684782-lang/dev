import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { supabase } from '../lib/supabase'
import { Session } from '@supabase/supabase-js'

interface User {
  access_token: string
  rol: string
  usuario_id: string
}

interface AuthContextType {
  user: User | null
  login: (dni: string, clave: string) => Promise<void>
  logout: () => void
  isAuthenticated: boolean
}

const AuthContext = createContext<AuthContextType>(null!)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)

  useEffect(() => {
    const session = supabase.auth.getSession()
    session.then(({ data: { session } }) => {
      if (session) {
        setUser({
          access_token: session.access_token,
          rol: session.user.user_metadata?.rol || 'administrador',
          usuario_id: session.user.id,
        })
      }
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event: string, session: Session | null) => {
        if (session) {
          setUser({
            access_token: session.access_token,
            rol: session.user.user_metadata?.rol || 'administrador',
            usuario_id: session.user.id,
          })
        } else {
          setUser(null)
        }
      }
    )

    return () => subscription?.unsubscribe()
  }, [])

  const login = async (dni: string, clave: string) => {
    const email = `${dni}@incasur.app`
    const { error } = await supabase.auth.signInWithPassword({ email, password: clave })
    if (error) throw error
  }

  const logout = async () => {
    await supabase.auth.signOut()
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, login, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)
