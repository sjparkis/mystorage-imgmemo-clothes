alter table organizations enable row level security;
alter table organization_members enable row level security;
alter table storages enable row level security;
alter table clothes enable row level security;
alter table clothes_tags enable row level security;

create or replace function is_org_member(p_org_id uuid)
returns boolean language sql security definer as $$
  select exists (
    select 1 from organization_members
    where org_id = p_org_id and user_id = auth.uid()
  );
$$;

create policy "org_members_select" on organizations for select using (is_org_member(id));
create policy "org_owner_update" on organizations for update using (owner_id = auth.uid());
create policy "org_owner_delete" on organizations for delete using (owner_id = auth.uid());
create policy "org_insert" on organizations for insert with check (owner_id = auth.uid());

create policy "members_select" on organization_members for select using (is_org_member(org_id));
create policy "members_insert" on organization_members for insert with check (org_id in (
  select id from organizations where owner_id = auth.uid()
));

create policy "storages_select" on storages for select using (is_org_member(org_id));
create policy "storages_all" on storages for all using (is_org_member(org_id));

create policy "clothes_select" on clothes for select using (is_org_member(org_id));
create policy "clothes_all" on clothes for all using (is_org_member(org_id));

create policy "clothes_tags_select" on clothes_tags for select using (
  cloth_id in (select id from clothes where is_org_member(org_id))
);
create policy "clothes_tags_all" on clothes_tags for all using (
  cloth_id in (select id from clothes where is_org_member(org_id))
);
