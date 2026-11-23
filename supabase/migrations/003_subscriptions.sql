create table subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null unique,
  plan text check (plan in ('free','ad_free','basic','ai_voice')) not null default 'free',
  billing_cycle text check (billing_cycle in ('monthly','yearly')),
  status text check (status in ('active','cancelled','expired')) not null default 'active',
  started_at timestamptz default now(),
  expires_at timestamptz,
  revenuecat_id text
);

alter table subscriptions enable row level security;
create policy "subscription_select" on subscriptions
  for select using (user_id = auth.uid());

create or replace function create_default_subscription()
returns trigger language plpgsql security definer as $$
begin
  insert into subscriptions(user_id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function create_default_subscription();
