create or replace view admin_stats as
select
  (select count(*) from auth.users) as total_users,
  (select count(*) from organizations) as total_orgs,
  (select count(*) from storages) as total_storages,
  (select count(*) from clothes) as total_clothes,
  (select count(*) from subscriptions where plan = 'ad_free' and status = 'active') as ad_free_count,
  (select count(*) from subscriptions where plan = 'basic' and status = 'active') as basic_count,
  (select count(*) from subscriptions where plan = 'ai_voice' and status = 'active') as ai_voice_count;

revoke all on admin_stats from anon, authenticated;
