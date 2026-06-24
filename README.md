# Drivenode Votazione

App di votazione mobile-friendly per eventi Drivenode. I partecipanti scansionano un QR, votano fino a 3 "caselle" (es. auto numerate) e vengono reindirizzati al sito **drivenode.netlify.app**. Un pannello admin permette di gestire numero di caselle, nomi, apertura/chiusura voto (es. finestra di 5 minuti) e vedere i risultati live.

Pensata per essere riutilizzata ad altri eventi: basta cambiare le impostazioni dall'admin, non serve toccare il codice.

## Struttura

```
drivenode-vote/
├── index.html          ← pagina pubblica di voto (quella nel QR)
├── admin.html          ← pannello admin (privato, non condividere il link pubblicamente)
├── assets/
│   ├── style.css
│   └── config.js       ← qui vanno le tue credenziali Supabase
└── supabase-schema.sql ← script da eseguire una volta su Supabase
```

## Setup (15 minuti, una volta sola)

### 1. Crea un progetto Supabase (gratis)
1. Vai su https://supabase.com → crea un account → "New project"
2. Scegli un nome e una password per il DB, regione vicina (es. Frankfurt)
3. Aspetta che il progetto sia pronto (~2 minuti)

### 2. Crea le tabelle
1. Nel progetto Supabase vai su **SQL Editor → New query**
2. Apri il file `supabase-schema.sql` di questo repo, copia tutto il contenuto, incollalo ed esegui (▶️ Run)
3. Questo crea le tabelle `items` (150 caselle pronte) e `config` (impostazioni), già con i permessi giusti

### 3. Collega le credenziali
1. In Supabase vai su **Project Settings → API**
2. Copia **Project URL** e **anon public key**
3. Apri `assets/config.js` e sostituisci:
   ```js
   const SUPABASE_URL = "https://YOUR-PROJECT.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";
   ```

### 4. Cambia la password admin (importante!)
Nello schema SQL la password admin di default è `drivenode2026`. Cambiala subito:
- In Supabase: **Table Editor → config → riga `admin_password`** → modifica il valore
  (oppure dal pannello `admin.html` non è possibile cambiarla, va fatto da Supabase direttamente)

### 5. Pubblica su Netlify
1. Crea un nuovo repository su GitHub e carica tutto il contenuto di questa cartella
2. Su https://app.netlify.com → "Add new site" → "Import from Git" → seleziona il repository
3. Non serve nessun build command: è un sito statico (lascia vuoto "Build command", "Publish directory" = `/`)
4. Deploy → otterrai un URL tipo `https://drivenode-vote.netlify.app`

## Uso il giorno dell'evento

1. Apri `tuosito.netlify.app/admin.html`, accedi con la password
2. Imposta titolo evento, numero caselle (default 150), voti massimi (default 3), URL di redirect
3. Quando vuoi far votare: imposta i minuti (es. 5) e clicca **"Apri votazioni"** → da quel momento la pagina pubblica si attiva per i minuti scelti, poi si chiude da sola
4. Genera un QR code che punta a `tuosito.netlify.app` (puoi usare un generatore gratuito come https://www.qr-code-generator.com) e mettilo negli schermi/poster dell'evento
5. I partecipanti scansionano, votano (max 3 scelte), confermano, e vengono reindirizzati automaticamente a drivenode.netlify.app
6. Guarda i risultati live in tempo reale nella sezione "Risultati live" dell'admin

## Note tecniche importanti

- **Anti-voto-doppio**: gestito solo lato browser (localStorage). Un partecipante non può rivotare dallo stesso telefono/browser, ma teoricamente potrebbe farlo cambiando browser o cancellando i dati. Per un evento informale è più che sufficiente; se in futuro serve un controllo più rigido (es. un voto per pettorina/biglietto), si può aggiungere un codice univoco da inserire prima di votare.
- **Riutilizzo per altri eventi**: tutto è configurabile dall'admin (titolo, numero caselle, nomi, voti massimi, URL redirect, apertura/chiusura). Per un evento completamente nuovo basta azzerare i voti e i nomi delle caselle.
- **Sicurezza password admin**: è un controllo semplice lato client, adatto per uso interno staff. Non è un sistema di autenticazione enterprise — non condividere il link admin pubblicamente.
- **Mobile friendly**: la griglia si adatta automaticamente a schermi piccoli; tutto visibile senza scroll eccessivo anche con 150 caselle.
