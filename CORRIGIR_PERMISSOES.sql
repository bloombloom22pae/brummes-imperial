-- BRUMMÊS IMPERIAL — corrigir permissões do backend (executar uma vez no Supabase SQL Editor)
-- Mantém RLS ativo e não libera acesso a visitantes (anon/authenticated).
alter table public.imperial_users enable row level security;
revoke all on table public.imperial_users from anon, authenticated;
grant usage on schema public to service_role;
grant select, insert, update on table public.imperial_users to service_role;
-- O papel service_role normalmente ignora RLS no Supabase.
-- Caso o erro 42501 persista, verificar a função/credenciais e a mensagem no servidor.
