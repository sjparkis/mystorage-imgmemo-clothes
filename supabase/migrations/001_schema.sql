create table organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner_id uuid references auth.users(id) not null,
  created_at timestamptz default now()
);

create table organization_members (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references organizations(id) on delete cascade not null,
  user_id uuid references auth.users(id) not null,
  role text check (role in ('owner', 'member')) not null default 'member',
  joined_at timestamptz default now(),
  unique(org_id, user_id)
);

create table storages (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references organizations(id) on delete cascade not null,
  name text not null,
  photo_url text,
  qr_code uuid default gen_random_uuid() not null unique,
  description text,
  created_at timestamptz default now()
);

create table clothes (
  id uuid primary key default gen_random_uuid(),
  org_id uuid references organizations(id) on delete cascade not null,
  storage_id uuid references storages(id) on delete set null,
  photo_url text,
  name text,
  created_by uuid references auth.users(id),
  created_at timestamptz default now()
);

create table tags (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  category text check (category in ('color','type','season','brand','custom')) not null
);

create table clothes_tags (
  id uuid primary key default gen_random_uuid(),
  cloth_id uuid references clothes(id) on delete cascade not null,
  tag_id uuid references tags(id) on delete cascade not null,
  ai_generated boolean default false,
  unique(cloth_id, tag_id)
);
