-- ============================================================
-- DRIVENODE VOTAZIONE — Schema Supabase
-- Esegui questo script intero in: Supabase > SQL Editor > New query > Run
-- ============================================================

-- Tabella delle "cose da votare" (es. auto numerate 1..150)
create table if not exists items (
  id bigint generated always as identity primary key,
  number int not null,
  name text not null default '',
  votes int not null default 0,
  active boolean not null default true
);

-- Tabella di configurazione (chiave/valore) — usata dall'admin
create table if not exists config (
  key text primary key,
  value text
);

-- Configurazione iniziale
insert into config (key, value) values
  ('event_title', 'Drivenode Votazione'),
  ('max_votes_per_person', '3'),
  ('num_items', '150'),
  ('redirect_url', 'https://drivenode.netlify.app'),
  ('voting_open', 'false'),
  ('voting_closes_at', ''),
  ('admin_password', 'drivenode2026')
on conflict (key) do nothing;

-- Popola automaticamente 150 caselle numerate 1..150 (se non esistono già)
insert into items (number, name)
select gs, ''
from generate_series(1, 150) as gs
where not exists (select 1 from items);

-- Abilita Row Level Security
alter table items enable row level security;
alter table config enable row level security;

-- Tutti possono LEGGERE items e config (pagina pubblica + admin)
create policy "public read items" on items for select using (true);
create policy "public read config" on config for select using (true);

-- Tutti possono AGGIORNARE i voti (incremento contatore) — necessario perché non ci sono login
-- NB: la sicurezza vera è lasciata al controllo lato client (localStorage) + onestà dei partecipanti.
create policy "public update votes" on items for update using (true);

-- Solo per l'admin: update/insert/delete su items e config.
-- Qui semplificato: permettiamo update/insert anche da pubblico sulla tabella config
-- perché l'autenticazione admin è gestita lato client con password (vedi admin.html).
create policy "public update config" on config for update using (true);
create policy "public insert config" on config for insert with check (true);
create policy "public insert items" on items for insert with check (true);
create policy "public delete items" on items for delete using (true);

-- Funzione per incrementare un voto in modo atomico (evita race condition)
create or replace function increment_vote(item_id bigint)
returns void as $$
begin
  update items set votes = votes + 1 where id = item_id;
end;
$$ language plpgsql;
