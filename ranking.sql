-- Execute no SQL Editor do Supabase. A tabela antiga imperial_scores não é utilizada.
create extension if not exists pgcrypto;
create table if not exists public.imperial_users (
 id uuid primary key default gen_random_uuid(),
 username text not null unique check (username ~ '^[A-Za-z0-9_]{3,24}$'),
 password_hash text not null,
 salt text not null,
 xp integer not null default 0 check (xp >= 0),
 created_at timestamptz not null default now()
);
alter table public.imperial_users enable row level security;
-- Nenhuma política pública: somente o backend com chave service_role acessa esta tabela.
revoke all on public.imperial_users from anon, authenticated;

-- BRUMMÊS IMPERIAL — corrigir permissões do backend (executar uma vez no Supabase SQL Editor)
-- Mantém RLS ativo e não libera acesso a visitantes (anon/authenticated).
alter table public.imperial_users enable row level security;
revoke all on table public.imperial_users from anon, authenticated;
grant usage on schema public to service_role;
grant select, insert, update on table public.imperial_users to service_role;
-- O papel service_role normalmente ignora RLS no Supabase.
-- Caso o erro 42501 persista, verificar a função/credenciais e a mensagem no servidor.
