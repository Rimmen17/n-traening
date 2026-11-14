-- N Træning: one private row per person in the shared Krarim project (rdabjsryzearizqbafpu).
-- Adds one new table; touches nothing that Krarim, Kririm or The Rimmens use.
create table if not exists public.training_state (
  owner uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.training_state enable row level security;

revoke all on public.training_state from anon, authenticated;
grant select, insert, update, delete on public.training_state to authenticated;

create policy "training: read own" on public.training_state
  for select to authenticated using (owner = auth.uid());
create policy "training: create own" on public.training_state
  for insert to authenticated with check (owner = auth.uid());
create policy "training: change own" on public.training_state
  for update to authenticated using (owner = auth.uid()) with check (owner = auth.uid());
create policy "training: delete own" on public.training_state
  for delete to authenticated using (owner = auth.uid());
