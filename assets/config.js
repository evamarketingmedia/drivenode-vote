// ============================================================
// CONFIGURAZIONE SUPABASE
// Sostituisci questi due valori con quelli del tuo progetto Supabase
// (Project Settings > API > Project URL / anon public key)
// ============================================================
const SUPABASE_URL = "https://bcrdiriaqsakxzdiorcb.supabase.co";
const SUPABASE_ANON_KEY ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJjcmRpcmlhcXNha3h6ZGlvcmNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIzMTY1NDYsImV4cCI6MjA5Nzg5MjU0Nn0.F10KWpzcOafMl-51d9nAqkFMnkQhMlc7zBBDddHIZko";
const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
