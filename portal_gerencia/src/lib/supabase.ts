import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://jznjjmwzctpclilemryj.supabase.co'
const supabaseAnonKey =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6bmpqbXd6Y3RwY2xpbGVtcnlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxODEyMDUsImV4cCI6MjA5Mzc1NzIwNX0.mc9w-E40YEQfXsoTpmwHLWskxoIV8PTlg8Q_28a5cus'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export const edgeFunctionBase = `${supabaseUrl}/functions/v1`
