grant usage on schema public to authenticated;

grant select, insert, update, delete on public.organizations to authenticated;
grant select, insert, update, delete on public.organization_members to authenticated;
grant select, insert, update, delete on public.storages to authenticated;
grant select, insert, update, delete on public.clothes to authenticated;
grant select, insert, update, delete on public.clothes_tags to authenticated;
grant select on public.subscriptions to authenticated;
