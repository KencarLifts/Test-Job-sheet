-- Run once in Supabase SQL Editor if you already ran the older schema.sql
drop policy if exists "docs insert" on public.documents;
drop policy if exists "docs update" on public.documents;
create policy "docs insert" on public.documents for insert to authenticated with check (is_approved() and created_by=auth.uid());
create policy "docs update" on public.documents for update to authenticated
  using (is_approved() and (created_by=auth.uid() or is_admin()))
  with check (is_approved() and (created_by=auth.uid() or is_admin()));
