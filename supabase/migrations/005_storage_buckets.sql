insert into storage.buckets (id, name, public)
values
  ('clothes-photos', 'clothes-photos', false),
  ('storage-photos', 'storage-photos', false)
on conflict (id) do nothing;

create policy "clothes-photos: 소유자 업로드"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'clothes-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "clothes-photos: 소유자 조회"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'clothes-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "clothes-photos: 소유자 삭제"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'clothes-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "storage-photos: 소유자 업로드"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'storage-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "storage-photos: 소유자 조회"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'storage-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "storage-photos: 소유자 삭제"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'storage-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
