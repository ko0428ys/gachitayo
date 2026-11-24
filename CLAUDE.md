# 같이타요 (gachitayo) — 작업 인계 노트

세명대학교·제천 택시 동승(합승) 앱. 평생교육방법론 **리빙랩 발표용 시제품**.
만든 사람: 김용승 (GitHub `ko0428ys`). 사이트 목표 주소: https://ko0428ys.github.io/gachitayo/

## 목표 (지금 하던 일)
학교 주변 포스터 + 에브리타임 홍보 → **QR 찍으면 바로 이 사이트로 들어와서 실제로 방을 만들고 같이 타는 것.**

진행 상황 (2026-11-25): GitHub Pages 켜짐, Firebase 연결 코드 들어감(`bootFirebase()`), 포스터 완성(Claude Design 아티팩트). 사용자가 Firebase 콘솔에서 Google 로그인·승인된 도메인·Firestore 생성·규칙 붙여넣기를 해야 실사용 가능.

원래 계획:
1. **Firebase로 데이터 옮기기** — 지금 `index.html`은 Claude Artifact의 `db`/`user` 기능(`window.claude.use(...)`)으로 공유 데이터를 쓰고, 그게 없으면(=GitHub Pages) **로컬 체험 모드**(localStorage, 예시 데이터)로 돈다. GitHub Pages에서는 지금 체험 모드만 된다.
   - Firebase Spark(무료): Google 로그인(Auth) + Firestore (asia-northeast3 서울, 프로덕션 모드)
   - 사용자가 `firebaseConfig`를 줘야 함. Auth → 승인된 도메인에 `ko0428ys.github.io` 추가 필요.
   - 보안 규칙: `firestore.rules` (각자 `<컬렉션>/<내 uid>` 문서만 쓰기, 로그인한 사람은 모두 읽기)
   - 바꿀 곳: `boot()` 안의 `claude.use("db")` / `claude.use("user")` 부분과 `writeMine(coll, doc)`.
     - `db.doc(coll+"/"+me).set(doc)` → Firestore `setDoc(doc(fs, coll, uid), data)`
     - `db.collection(coll).limit(1000).onSnapshot(...)` → `onSnapshot(collection(fs, coll), ...)`
     - `user.profiles(ids)` → 이름은 각자 `rides/<uid>` 등에 `name` 필드로 저장하거나 `profiles/<uid>` 컬렉션 추가(규칙에도 추가)
     - 로그인 안 했으면 "Google로 로그인" 버튼 + 체험 모드 유지
   - Firebase SDK는 CDN 모듈: `https://www.gstatic.com/firebasejs/<버전>/firebase-app.js` 등
2. **GitHub Pages 켜기** — Settings → Pages → Branch `main` / `(root)` → Save
3. **QR 코드 + 포스터** — QR은 위 사이트 주소. 포스터는 A4/A3 인쇄용, 앱 색(노랑 #F0B01E, 먹색 #15171C), "세명대 ↔ 제천역 택시 같이 타요, 1인 ~2,000원대" 느낌. 학교 게시 승인 필요할 수 있음.

## 파일
- `index.html` — 앱 전체 (HTML+CSS+JS 한 파일, 약 90KB). 바닐라 JS IIFE.
- `firestore.rules` — Firebase 보안 규칙 초안 (Firestore 콘솔 → 규칙 탭에 붙여넣기)
- `android/` — APK 소스 (apktool 형식, smali). `android/build.sh`로 빌드 (Java + `tools/apktool.jar`, `tools/signer.jar` 필요, 링크는 스크립트 안에)
  - 패키지 `kr.semyung.gachitayo`, minSdk 24 / targetSdk 34, versionName 1.6 (versionCode 7)
  - `MainActivity.smali`: WebView로 `file:///android_asset/index.html` 로드, JS·DOM storage 켬, 뒤로가기 = goBack
  - `ExtClient.smali`: file:// 아닌 링크(카톡 오픈채팅 등)는 외부 앱(ACTION_VIEW)으로 연다
  - Firebase로 바꾸면 APK는 `loadUrl("https://ko0428ys.github.io/gachitayo/")`로 바꾸는 게 편함 (Google 로그인은 WebView에서 막히므로 Custom Tab/브라우저 열기 고려)

## 앱 기능 (이미 구현됨)
- 출발/도착: 세명대 정문, 제천역, 제천 버스터미널, 제천 중앙시장, 롯데마트 제천점, 제천시청, 의림지 + 직접 입력
- **예상 요금**: 충북 택시 기본 4,000원/2km, 이후 132m당 100원 (비공식 출처 glasswallet.com). 거리 = 직선거리(haversine) × 1.35. 1인당 = 올림(100원 단위).
- 방 만들기/참여/나가기, 좌석 2~4, 만날 곳, **캘린더 날짜 선택**(60일), 시간
- **카카오톡 오픈채팅 링크 필수** (`https://open.kakao.com/o/...` 형식 검사), 참여자에게 "오픈채팅 들어가기" 버튼
- 이용 안내 (방장용/탑승자용 탭 + 매너)
- **노쇼 방지**: 보증금 1,000원(시뮬레이션), 노쇼 2회 = 이용 정지, 출발 10분 전부터 나가기 잠금, 출발 20분 전~30분 후 "도착 체크인", 출발 후 24시간 안에 체크인한 사람끼리 노쇼 투표(본인 제외 과반), 체크인했거나 이의 제기하면 "분쟁"(벌점 아님), 이의 제기는 30일에 1번
- **이용 통계** 탭: 요약 숫자 4개, 노선별 막대, 요일×시간대 히트맵, 설문 결과(또 탈래요/글쎄요/아니요) 막대 + 불편 사항 + 한 줄 후기
- **탑승 후 한 줄 설문** (3일 안)
- 데이터 구조 (컬렉션마다 사람당 문서 1개, 위조 방지):
  - `rides/<uid>` `{list:{rid: ride}}`
  - `joins/<uid>` `{list:{rideKey: ts}}` (rideKey = host + "~" + rid)
  - `checkins/<uid>` `{at:{key: ts}, obj:{key: ts}}`
  - `votes/<uid>` `{list:{key: [노쇼라고 표시한 uid들]}}`
  - `surveys/<uid>` `{list:{key:{again, issues, note, at, skipped}}}`
- 디자인 토큰: --bg #F2F3F5, --ink #15171C, --accent #F0B01E, --led #E0352B, --ok #1B8F5A, 폰트 Do Hyeon(제목) + IBM Plex Sans KR. 다크 모드 있음.

## 주의
- 예시 데이터의 오픈채팅 링크는 가짜(`sExample0`)로 바꿔 둠.
- 카톡·에타 인앱 브라우저에서는 구글 로그인이 막혀서 '브라우저로 열기' 안내를 띄움 (`IN_APP`, `externalUrl()`).
- APK(file://)는 Firebase 없이 체험 모드 + 사이트 링크만.
- 사용자는 한국어로, 짧고 쉬운 말로 설명받는 걸 선호함. 코딩 초보.
