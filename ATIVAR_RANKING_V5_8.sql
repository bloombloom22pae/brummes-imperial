-- BRUMMÊS V5.8: executar UMA VEZ no Supabase SQL Editor.
-- Mantém RLS; só a função Netlify com service_role pode iniciar/finalizar quizzes.
create table if not exists public.imperial_quiz_runs (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.imperial_users(id) on delete cascade,
 answers jsonb not null,
 consumed boolean not null default false,
 created_at timestamptz not null default now()
);
alter table public.imperial_quiz_runs enable row level security;
revoke all on public.imperial_quiz_runs from anon, authenticated;
grant usage on schema public to service_role;
grant select, insert, update on public.imperial_quiz_runs to service_role;
grant select, update on public.imperial_users to service_role;
create or replace function public.imperial_complete_quiz(p_user_id uuid,p_run_id uuid,p_answers jsonb)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v_run public.imperial_quiz_runs%rowtype; v_points integer; v_xp integer;
begin
 select * into v_run from public.imperial_quiz_runs
 where id=p_run_id and user_id=p_user_id for update;
 if not found or v_run.consumed or v_run.created_at < now()-interval '2 hours'
    or jsonb_typeof(p_answers) <> 'array' or jsonb_array_length(p_answers) <> 10 then
   return jsonb_build_object('ok',false);
 end if;
 select count(*)::integer into v_points
 from jsonb_array_elements_text(v_run.answers) with ordinality as a(answer,idx)
 join jsonb_array_elements_text(p_answers) with ordinality as b(answer,idx)
 on a.idx=b.idx and a.answer=b.answer;
 update public.imperial_quiz_runs set consumed=true where id=p_run_id;
 update public.imperial_users set xp=xp+v_points*100 where id=p_user_id returning xp into v_xp;
 return jsonb_build_object('ok',true,'points',v_points,'xp',v_xp);
end;$$;
revoke all on function public.imperial_complete_quiz(uuid,uuid,jsonb) from public, anon, authenticated;
grant execute on function public.imperial_complete_quiz(uuid,uuid,jsonb) to service_role;
