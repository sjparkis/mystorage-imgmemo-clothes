ALTER TABLE storages
  ADD COLUMN storage_type TEXT NOT NULL DEFAULT 'normal'
  CHECK (storage_type IN ('normal', 'trash', 'for_sale'));

CREATE TABLE user_settings (
  user_id    UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  show_trash BOOLEAN NOT NULL DEFAULT true,
  show_sale  BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "own_settings" ON user_settings
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());
