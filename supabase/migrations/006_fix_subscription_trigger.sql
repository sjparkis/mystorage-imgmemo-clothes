create or replace function create_default_subscription()
returns trigger language plpgsql security definer
set search_path = public
as $$
begin
  insert into public.subscriptions(user_id)
  values (new.id)
  on conflict (user_id) do nothing;
  return new;
exception when others then
  return new;
end;
$$;
