-- Purchase Ledger — Supabase schema
-- Paste this whole file into: Supabase Dashboard → SQL Editor → New query → Run

create extension if not exists "pgcrypto";

create table if not exists items (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  unit text not null,
  created_at timestamptz not null default now()
);

create table if not exists entries (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  item text not null,
  qty numeric not null,
  unit text not null,
  user_name text,
  user_phone text,
  created_at timestamptz not null default now()
);

create table if not exists last_seen (
  phone text primary key,
  last_seen_at timestamptz not null default now()
);

-- Row Level Security: this app has no real login system (name/phone is just a
-- label, not verified), so it works the same way the shared link always did —
-- anyone with your Supabase URL + anon key can read and write. That matches a
-- small trusted-team tool. Do not use this schema for anything sensitive.
alter table items enable row level security;
alter table entries enable row level security;
alter table last_seen enable row level security;

create policy "allow all on items" on items for all using (true) with check (true);
create policy "allow all on entries" on entries for all using (true) with check (true);
create policy "allow all on last_seen" on last_seen for all using (true) with check (true);

-- Enable realtime so all open devices sync instantly
alter publication supabase_realtime add table entries;
alter publication supabase_realtime add table items;
