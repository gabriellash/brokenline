-- BrokenLine.io — Supabase schema
-- Run this entire file in the Supabase SQL editor

create table if not exists rooms (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  host_id text not null,
  player_count int not null default 0,
  current_step int not null default 0,
  status text not null default 'lobby',  -- lobby | playing | finished
  players jsonb not null default '[]',
  created_at timestamptz default now()
);

create table if not exists game_steps (
  id uuid primary key default gen_random_uuid(),
  room_id uuid references rooms(id) on delete cascade,
  step_number int not null,
  type text not null,  -- sentence | description
  content text not null,
  player_name text not null,
  created_at timestamptz default now()
);

-- Indexes for performance
create index if not exists idx_rooms_code on rooms(code);
create index if not exists idx_game_steps_room_id on game_steps(room_id);
create index if not exists idx_game_steps_step_number on game_steps(room_id, step_number);

-- Disable RLS for simplicity (enable and add policies for production)
alter table rooms disable row level security;
alter table game_steps disable row level security;
