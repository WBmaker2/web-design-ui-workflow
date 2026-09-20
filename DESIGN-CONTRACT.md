# Web Design UI Workflow 소개 페이지 디자인 계약

## Problem

웹 UI를 만드는 사람에게 `web-design-ui-workflow`의 역할과 실제 글로벌 설치 절차를 한 화면 흐름으로 설명합니다. 과장된 제품 지표나 가상 사용 사례 없이, 저장소에 존재하는 번들 구성과 설치 명령만 사용합니다.

## Audience

Codex Desktop 또는 Codex CLI에서 웹 UI 작업을 시작하려는 개발자와 교육용 웹앱 제작자입니다.

## Anchor

Swiss — 스킬의 핵심 가치인 명확한 순서, 기준, 검증을 흰 바탕·검은 활자·한 가지 빨간 신호색·헤어라인 그리드로 표현합니다. 무난한 SaaS 카드 모음 대신 편집 디자인의 안내 포스터처럼 읽히게 합니다.

## Visible differentiator

설치 페이지 전체를 하나의 빨간 진행선으로 묶어 `frontend-design → frontend-ui-standards → accessibility → Playwright MCP`의 순서를 시각적으로 반복합니다.

## System

- Palette: `#F7F7F8`, `#171717`, `#E4002B`, `#D5D7DB`
- Typography: Helvetica Neue / Arial 계열 sans-serif, 코드에는 시스템 고정폭 글꼴
- Structure: 좌측 정렬, 비대칭 2열 영웅 영역, 얇은 규칙선, 정사각형에 가까운 모듈
- Texture: 생성한 단색 기하학 히어로 일러스트와 CSS 그리드만 사용
- Motion: 핵심 CTA의 짧은 `gi-pulse` 아우라와 메뉴/대화상자 전환. `prefers-reduced-motion`에서는 정지

## Content rules

- 실제 번들과 README, 설치 스크립트에 있는 이름·버전·경로만 사용합니다.
- 고객·사용자·성능 수치·가짜 후기·가짜 제품 화면은 만들지 않습니다.
- 표준 버튼 문구를 유지하고, 코드 복사 상태는 `aria-live`로 알립니다.
- `업데이트 내역` 버튼에 2026-09-20의 페이지 추가 내역을 기록합니다.

## Accessibility contract

- `header`, `nav`, `main`, `section`, `footer`, `ol`, `details`, `dialog` 등 네이티브 구조를 우선합니다.
- 건너뛰기 링크, 논리적인 heading 순서, 키보드 포커스, 44px 이상 터치 영역, `alt` 텍스트를 제공합니다.
- 명암은 본문 4.5:1 이상을 목표로 하며, 상태를 색상만으로 전달하지 않습니다.
- 수평 오버플로우를 숨겨 문제를 감추지 않고, 모바일에서 코드와 그리드가 자연스럽게 재배치되도록 합니다.
