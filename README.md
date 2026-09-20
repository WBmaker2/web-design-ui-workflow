# Web Design UI Workflow

Chat에서 생성한 웹 UI 작업용 Codex 스킬과 글로벌 설치 번들을 보존한 저장소입니다.

## 구성

- `attachments/extracted/web-design-ui-workflow/`: 오케스트레이터 단독 스킬
- `attachments/extracted/web-design-ui-global-installer/`: 하위 스킬 3개와 글로벌 설치 스크립트
- `attachments/archives/`: 원본 ZIP 보관본
- `ATTACHMENTS-ANALYSIS.md`: 첨부 자료 분석 및 설치 범위 기록

## 전역 설치

글로벌 설치 번들의 `install.sh`는 다음 Codex 구성요소를 설치합니다.

- `frontend-design`
- `frontend-ui-standards`
- `accessibility`
- `web-design-ui-workflow`
- Playwright MCP `@playwright/mcp@0.0.81`

설치 전 `install.sh`와 `README.md`를 검토하고, 설치 후 `skills/web-design-ui-workflow/scripts/doctor.sh`로 상태를 확인하십시오.

## 출처와 라이선스

하위 스킬의 출처·커밋·라이선스는 각 `PROVENANCE.md`와 `LICENSE` 파일에 기록되어 있습니다.
