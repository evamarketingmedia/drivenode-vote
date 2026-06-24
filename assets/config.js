// ============================================================
// CONFIGURAZIONE SUPABASE
// Sostituisci questi due valori con quelli del tuo progetto Supabase
// (Project Settings > API > Project URL / anon public key)
// ============================================================
const SUPABASE_URL = "https://YOUR-PROJECT.supabase.co";
const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
