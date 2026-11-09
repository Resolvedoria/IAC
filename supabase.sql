-- IAC · Resolvedoria
-- Rode este arquivo inteiro no Supabase: SQL Editor > New query > colar > Run.
-- Antes, troque o e-mail de administrador abaixo se for usar outro.

create table if not exists public.iac_respostas (
  id uuid primary key default gen_random_uuid(),
  criado_em timestamptz not null default now(),
  empresa text not null check (char_length(empresa) between 1 and 200),
  email text not null check (char_length(email) between 3 and 200),
  momento text not null check (momento in ('inicial', 'final')),
  respostas jsonb not null,
  pontos int check (pontos between 0 and 100)
);

create table if not exists public.iac_validacoes (
  resposta_id uuid primary key references public.iac_respostas(id) on delete cascade,
  notas jsonb not null,
  atualizado_em timestamptz not null default now()
);

alter table public.iac_respostas enable row level security;
alter table public.iac_validacoes enable row level security;

create or replace function public.iac_is_admin() returns boolean
language sql stable as $$
  select coalesce(auth.jwt() ->> 'email', '') = 'joao@resolvedoria.com.br'
$$;

-- Qualquer pessoa com o link pode ENVIAR respostas, mas não pode ler nada.
drop policy if exists "envio publico" on public.iac_respostas;
create policy "envio publico" on public.iac_respostas
  for insert to anon, authenticated with check (true);

-- Só o administrador lê, corrige e apaga respostas.
drop policy if exists "admin le respostas" on public.iac_respostas;
create policy "admin le respostas" on public.iac_respostas
  for select to authenticated using (public.iac_is_admin());
drop policy if exists "admin altera respostas" on public.iac_respostas;
create policy "admin altera respostas" on public.iac_respostas
  for update to authenticated using (public.iac_is_admin()) with check (public.iac_is_admin());
drop policy if exists "admin apaga respostas" on public.iac_respostas;
create policy "admin apaga respostas" on public.iac_respostas
  for delete to authenticated using (public.iac_is_admin());

-- Validações: só o administrador.
drop policy if exists "admin validacoes" on public.iac_validacoes;
create policy "admin validacoes" on public.iac_validacoes
  for all to authenticated using (public.iac_is_admin()) with check (public.iac_is_admin());

-- Permissões das funções da API (as regras acima continuam valendo).
grant usage on schema public to anon, authenticated;
grant insert on public.iac_respostas to anon, authenticated;
grant select, update, delete on public.iac_respostas to authenticated;
grant select, insert, update, delete on public.iac_validacoes to authenticated;
grant execute on function public.iac_is_admin() to anon, authenticated;

-- 09/11/2026: nome e cargo de quem preenche.
alter table public.iac_respostas
  add column if not exists nome text check (char_length(nome) <= 200),
  add column if not exists cargo text check (char_length(cargo) <= 100);
