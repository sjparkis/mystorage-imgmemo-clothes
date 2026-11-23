# MyStorage

옷 보관 위치를 사진·QR·AI 음성 검색으로 관리하는 앱

## 기술 스택

- **앱**: Flutter 3.x (iOS · Android · PWA)
- **백엔드**: Supabase (PostgreSQL + Edge Functions + Storage)
- **AI**: OpenAI GPT-4o-mini (이미지 태그, 음성 검색)
- **구독**: RevenueCat

## 프로젝트 구조

```
mystorage/          # Flutter 앱
supabase/           # DB 마이그레이션 & Edge Functions
dev-docs/           # 설계서, ERD, API 명세, 스토리보드
```

## 시작하기

```bash
# 로컬 Supabase 실행
supabase start

# Flutter 앱 실행
cd mystorage
flutter run
```

## 환경변수

`.env.local` 파일을 루트에 생성:

```
OPENAI_API_KEY=sk-...
```
