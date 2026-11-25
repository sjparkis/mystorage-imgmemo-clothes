-- 초대 코드 테이블
create table org_invites (
  id         uuid primary key default gen_random_uuid(),
  org_id     uuid references organizations(id) on delete cascade,
  code       text unique not null,
  created_by uuid references auth.users(id),
  created_at timestamptz default now(),
  expires_at timestamptz default now() + interval '48 hours',
  used_at    timestamptz,
  used_by    uuid references auth.users(id)
);

alter table org_invites enable row level security;

create policy "초대 생성: 조직 멤버"
  on org_invites for insert to authenticated
  with check (
    org_id in (select org_id from organization_members where user_id = auth.uid())
  );

create policy "초대 조회: 인증된 사용자"
  on org_invites for select to authenticated
  using (true);

create policy "초대 업데이트: 인증된 사용자"
  on org_invites for update to authenticated
  using (true);

-- 코드로 조직 참여 (데이터 마이그레이션 포함)
create or replace function join_org_with_code(invite_code text)
returns json
language plpgsql security definer as $$
declare
  v_invite   org_invites%rowtype;
  v_user_id  uuid := auth.uid();
  v_old_org  uuid;
  v_new_org  uuid;
begin
  select * into v_invite
  from org_invites
  where code = invite_code
    and expires_at > now()
    and used_at is null;

  if not found then
    raise exception 'invalid_or_expired';
  end if;

  v_new_org := v_invite.org_id;

  if exists (
    select 1 from organization_members
    where org_id = v_new_org and user_id = v_user_id
  ) then
    raise exception 'already_member';
  end if;

  -- 기존 조직 찾기
  select org_id into v_old_org
  from organization_members
  where user_id = v_user_id
  limit 1;

  -- 기존 데이터 새 조직으로 이동
  if v_old_org is not null and v_old_org != v_new_org then
    update storages set org_id = v_new_org where org_id = v_old_org;
    update clothes  set org_id = v_new_org where org_id = v_old_org;
    delete from organization_members where org_id = v_old_org and user_id = v_user_id;
    delete from organizations
    where id = v_old_org
      and not exists (select 1 from organization_members where org_id = v_old_org);
  end if;

  -- 새 조직에 멤버 추가
  insert into organization_members (org_id, user_id, role)
  values (v_new_org, v_user_id, 'member')
  on conflict do nothing;

  -- 초대 코드 사용 처리
  update org_invites
  set used_at = now(), used_by = v_user_id
  where id = v_invite.id;

  return json_build_object('success', true, 'org_id', v_new_org);
end;
$$;

-- 조직 멤버 목록 조회 (email 포함)
create or replace function get_org_members()
returns table(user_id uuid, email text, role text, joined_at timestamptz)
language plpgsql security definer as $$
begin
  return query
  select
    om.user_id,
    u.email::text,
    om.role,
    om.joined_at
  from organization_members om
  join auth.users u on u.id = om.user_id
  where om.org_id = (
    select org_id from organization_members
    where user_id = auth.uid()
    limit 1
  )
  order by om.joined_at;
end;
$$;

-- 멤버 추방 (owner만)
create or replace function remove_org_member(target_user_id uuid)
returns void
language plpgsql security definer as $$
declare
  v_org_id uuid;
  v_role   text;
begin
  select org_id, role into v_org_id, v_role
  from organization_members
  where user_id = auth.uid()
  limit 1;

  if v_role != 'owner' then
    raise exception 'not_owner';
  end if;

  if target_user_id = auth.uid() then
    raise exception 'cannot_remove_self';
  end if;

  delete from organization_members
  where org_id = v_org_id and user_id = target_user_id;
end;
$$;
