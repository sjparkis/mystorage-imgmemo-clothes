ALTER TABLE user_settings
  ADD COLUMN role TEXT NOT NULL DEFAULT 'user'
  CHECK (role IN ('user', 'manager', 'admin'));
