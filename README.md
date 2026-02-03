# 모기잡이 커뮤니티 (Mosquito Hunter Community)

모기를 창의적으로 잡은 순간을 공유하는 커뮤니티 플랫폼입니다.
수익의 50%는 말라리아 퇴치 단체에 기부됩니다.

## 주요 기능

- **게시물 업로드**: 사진/동영상으로 모기 퇴치 순간 공유
- **투표 시스템**: Upvote/Downvote로 최고의 헌터 선정
- **랭킹**: 일간/주간/월간 랭킹
- **댓글**: 게시물에 댓글 작성
- **소셜 로그인**: Google OAuth (Clerk)

## 기술 스택

| 영역 | 기술 |
|------|------|
| Backend | Ruby on Rails 8.1.2 |
| Database | PostgreSQL |
| Authentication | Clerk |
| File Upload | Cloudinary |
| CSS | Tailwind CSS v4 |
| Frontend | Hotwire (Turbo + Stimulus) |

## 시작하기

### 요구 사항

- Ruby 4.0+
- PostgreSQL 14+
- Node.js 18+

### 설치

```bash
# 저장소 클론
git clone <repository-url>
cd mosquito-community

# 의존성 설치
bundle install

# 환경 변수 설정
cp .env.example .env
# .env 파일 편집하여 API 키 입력

# 데이터베이스 설정
rails db:create db:migrate db:seed

# 서버 실행
bin/dev
```

### 환경 변수

`.env` 파일에 다음 변수들을 설정해야 합니다:

```env
# Clerk Authentication
CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_PRESET=mosquito_uploads

# Database (optional, defaults to local)
DATABASE_URL=postgres://...
```

## 프로젝트 구조

```
app/
├── controllers/
│   ├── concerns/
│   │   └── clerk_authenticatable.rb  # Clerk 인증
│   ├── posts_controller.rb           # 게시물 CRUD
│   ├── votes_controller.rb           # 투표 처리
│   ├── comments_controller.rb        # 댓글 처리
│   └── rankings_controller.rb        # 랭킹 조회
├── models/
│   ├── user.rb                       # 사용자
│   ├── post.rb                       # 게시물
│   ├── vote.rb                       # 투표
│   └── comment.rb                    # 댓글
├── views/
│   ├── layouts/application.html.erb  # 메인 레이아웃
│   ├── pages/home.html.erb           # 홈페이지
│   ├── posts/                        # 게시물 뷰
│   ├── rankings/                     # 랭킹 뷰
│   └── kaminari/                     # 페이지네이션
└── assets/
    └── tailwind/application.css      # 커스텀 CSS
```

## 개발 가이드

### 서버 실행

```bash
# 개발 서버 (포트 4000)
bin/dev

# 또는 개별 실행
rails server -p 4000
bin/rails tailwindcss:watch
```

### Tailwind CSS 빌드

```bash
# 수동 빌드
bundle exec rails tailwindcss:build

# 워치 모드
bundle exec rails tailwindcss:watch
```

### 데이터베이스

```bash
# 마이그레이션
rails db:migrate

# 시드 데이터
rails db:seed

# 리셋
rails db:reset
```

## API 엔드포인트

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | 홈페이지 |
| GET | `/posts` | 게시물 목록 |
| GET | `/posts/:id` | 게시물 상세 |
| POST | `/posts` | 게시물 생성 |
| PATCH | `/posts/:id` | 게시물 수정 |
| DELETE | `/posts/:id` | 게시물 삭제 |
| POST | `/posts/:id/votes` | 투표 |
| POST | `/posts/:id/comments` | 댓글 작성 |
| DELETE | `/posts/:id/comments/:id` | 댓글 삭제 |
| GET | `/rankings` | 랭킹 |

## 로드맵

- [ ] 아바타 시스템 - 아이템 수집 & 꾸미기
- [ ] 기부 대시보드 - 총액, 월별 차트
- [ ] Render 배포
- [ ] NFT 기능 (Polygon)

## 라이선스

MIT License

## 기여

기여는 언제나 환영합니다! Pull Request를 보내주세요.

---

Made with hate for mosquitoes.
