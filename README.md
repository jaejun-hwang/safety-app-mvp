# Safety App MVP

🏗️ **건설현장 안전관리 앱 시제품**

Flutter 기반으로 개발된 건설현장 안전관리용 모바일 앱입니다.  
작업허가서, 일일작업일보 등을 작성 및 백업 관리할 수 있으며, SQLite와 Firebase를 함께 활용합니다.

## 🚀 주요 기능

- 작업허가서 등록 및 수정, 삭제
- 작업허가서 목록 확인 및 상세보기
- 날짜 및 키워드 검색 필터
- CSV 파일로 내보내기 (로컬 저장)
- Firebase Cloud Firestore로 자동 백업

## 🛠️ 기술 스택

- Flutter 3.27.4
- Dart 3.6.2
- SQLite (로컬 저장)
- Firebase Firestore (클라우드 백업)
- CSV + Path Provider + Permission Handler

## ▶️ 실행 방법

```bash
flutter pub get
flutter run
```

## 📂 프로젝트 구조

```
lib/
├── models/
├── screens/
├── helpers/
└── utils/
```

## 📷 스크린샷

> 추후 스크린샷 추가 예정

## 📄 라이선스

MIT License