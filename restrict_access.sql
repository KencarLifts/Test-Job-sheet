-- Run once in Supabase SQL Editor (existing projects)
create or replace function public.is_mine(doc_author uuid, doc_tech text) returns boolean language sql stable security definer set search_path=public as
$$ select coalesce((select p.approved and (doc_author=p.id or (btrim(coalesce(doc_tech,''))<>'' and lower(btrim(doc_tech)) in (lower(btrim(coalesce(p.full_name,''))), lower(btrim(coalesce(p.email,'')))))) from profiles p where p.id=auth.uid()),false) $$;
drop policy if exists "docs read" on public.documents;
drop policy if exists "docs update" on public.documents;
-- administrators see everything; a technician sees only documents created by him or assigned to him (Technician name)
create policy "docs read" on public.documents for select to authenticated using (is_admin() or is_mine(created_by,tech));
create policy "docs update" on public.documents for update to authenticated
  using (is_admin() or is_mine(created_by,tech)) with check (is_admin() or is_mine(created_by,tech));
