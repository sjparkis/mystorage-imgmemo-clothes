-- 옷 실물 존재 여부: null=미확인, true=있음, false=없음
ALTER TABLE clothes ADD COLUMN IF NOT EXISTS is_present BOOLEAN DEFAULT NULL;
