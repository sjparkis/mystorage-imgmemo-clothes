create or replace function create_default_org()
returns trigger language plpgsql security definer
set search_path = public
as $$
declare
  v_org_id uuid;
begin
  insert into public.organizations(name, owner_id)
  values ('내 보관함', new.id)
  returning id into v_org_id;

  insert into public.organization_members(org_id, user_id, role)
  values (v_org_id, new.id, 'owner');

  return new;
exception when others then
  return new;
end;
$$;

create trigger on_auth_user_created_org
  after insert on auth.users
  for each row execute function create_default_org();
