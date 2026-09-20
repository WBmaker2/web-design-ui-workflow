# 첨부 스킬 자료 분석

분석일: 2026-09-20

## 1. 사용자 요청과 첨부 문서 지침의 구분

### 이번 사용자 요청

- 두 ZIP 파일을 현재 프로젝트 디렉터리로 복사한다.
- ZIP을 압축 해제한다.
- 압축 해제된 프로젝트 내용을 분석한다.

### 첨부 문서가 정의하는 별도 작업

- `web-design-ui-workflow`를 웹 UI 작업의 오케스트레이터로 사용한다.
- `frontend-design`, `frontend-ui-standards`, `accessibility`를 순서대로 적용한다.
- 정적 검사와 Playwright MCP 브라우저 QA를 수행한다.
- 전역 설치 스크립트로 `~/.codex` 또는 `$CODEX_HOME`을 수정하고 Playwright MCP 설정을 등록한다.

첨부 문서의 설치·구현·브라우저 QA 지침은 이번 요청의 분석 대상이지, 이번 turn에서 자동으로 실행할 사용자 승인 범위가 아니다.

## 2. 수행한 작업

- 원본 보존 복사:
  - `attachments/archives/web-design-ui-workflow-skill.zip`
  - `attachments/archives/web-design-ui-workflow-global-installer.zip`
- 압축 해제:
  - `attachments/extracted/web-design-ui-workflow/`
  - `attachments/extracted/web-design-ui-global-installer/`
- 설치 스크립트는 실행하지 않았다.
- 전역 `~/.codex`, Playwright 설정, 외부 저장소, 배포 대상은 변경하지 않았다.
- 압축 해제 전 프로젝트에는 실질 파일이 없었고 Git 저장소로 인식되지 않았다.

## 3. 파일 구성

### 스킬 단독 ZIP

`web-design-ui-workflow-skill.zip`은 오케스트레이터 하나를 담는다.

- `SKILL.md`: 웹 UI 작업의 전체 순서와 품질 기준
- `references/workflow.md`: 생성·스타일 변경·리팩터링·수리·리뷰 분기와 단계별 계약
- `references/quality-gates.md`: Blocking/Major/Minor/Manual review 분류
- `references/playwright-qa.md`: Playwright MCP의 viewport·기능·접근성·콘솔 검사
- `references/report-format.md`: 완료 보고 형식
- `scripts/doctor.sh`: 전역 의존성 설치 상태 확인
- `agents/openai.yaml`: 표시 이름과 암시적 호출 허용 설정
- `LICENSE`, `PROVENANCE.md`

### 글로벌 설치 ZIP

`web-design-ui-workflow-global-installer.zip`은 다음을 포함한다.

- 위 오케스트레이터의 동일한 복사본
- `frontend-design`
- `frontend-ui-standards`
- `accessibility`
- `config-snippet.toml`
- `install.sh`
- 설치 설명용 `README.md`

단독 ZIP의 오케스트레이터 트리와 설치 ZIP 내부의 오케스트레이터 트리는 `diff -qr` 기준으로 동일하다.

## 4. 핵심 동작 분석

1. 현재 코드베이스와 실행 경로를 조사한다.
2. `frontend-design`으로 문제·대상·시각적 anchor·차별점을 정한다.
3. `frontend-ui-standards`로 토큰·컴포넌트·반응형 관계·상태를 설계한다.
4. `accessibility`로 시맨틱 구조·키보드·포커스·폼·대체 텍스트·명암·reflow·reduced motion을 정의한다.
5. 최소 범위로 구현한다.
6. 프로젝트가 제공하는 정적 검사를 실행한다.
7. Playwright MCP로 `1440x900`, `768x1024`, `390x844`와 주요 사용자 흐름을 확인한다.
8. 원인 단위로 최대 3회의 수정·재검증을 수행한다.
9. 실행한 검사와 실행하지 못한 검사를 구분해 보고한다.

## 5. 각 하위 스킬의 역할

- `frontend-design`: 여덟 가지 시각적 anchor 중 하나를 선택하고, 색·타이포그래피·구조·질감의 일관성과 실제 정보 기반 콘텐츠를 요구한다.
- `frontend-ui-standards`: 전역 디자인 토큰, 컴포넌트 지표, 화면 지표를 분리하고 기존 컴포넌트 재사용·파생 관계·공통 상태를 우선한다.
- `accessibility`: 네이티브 HTML과 키보드 조작을 우선하며, 랜드마크·heading·label·focus·폼 오류·대체 텍스트·명암·확대·reduced motion·사람에 의한 검토를 요구한다.
- Playwright 참조 문서: 모양만 보고 작동한다고 주장하지 말고, 실제 상태 변화와 콘솔·리소스 실패를 확인하도록 한다.

## 6. 전역 설치 스크립트의 변경 범위

`install.sh`를 실행하면 기본적으로 `${CODEX_HOME:-$HOME/.codex}` 아래에 다음을 만든다 또는 교체한다.

- `skills/frontend-design/`
- `skills/frontend-ui-standards/`
- `skills/accessibility/`
- `skills/web-design-ui-workflow/`
- `config.toml`의 `[mcp_servers.playwright]`
- `web-design-ui-workflow.lock.json`
- timestamp가 붙은 `backups/web-design-ui-workflow/` 백업 디렉터리

Playwright MCP는 `@playwright/mcp@0.0.81`로 고정되며 `--headless`, `--isolated`, `--no-webmcp` 옵션을 사용하도록 설정된다. 기존 Playwright 섹션이 다른 설정이면 설치를 중단하도록 되어 있고, 기존 스킬·설정·lock 파일은 백업한다. 롤백은 설치 후 digest가 바뀌지 않은 파일만 제거·복원하도록 설계되어 있다.

## 7. 출처·무결성 확인

번들 내부 `PROVENANCE.md`가 선언한 출처와 고정값은 다음과 같다.

- `frontend-design`: MIT, commit `1641823c70438a5ca36e2a5ea43f6154e3e70b81`
- `frontend-ui-standards`: MIT, commit `0609cb07793ee1f8f6626c98042ee2e811f81735`
- `accessibility`: MIT, commit `2bf8ddcf87e09dd0caac609abb979cc19aca2555`
- Playwright MCP: Apache-2.0, `@playwright/mcp@0.0.81`

현재 확인한 로컬 ZIP SHA-256:

- `web-design-ui-workflow-skill.zip`: `4fb4f88c1a4e01eba1ee95a68c2f84b56155c4c93ca65ec4f153ae7267690b9a`
- `web-design-ui-workflow-global-installer.zip`: `668423d8a07eac1e8cf50d67160d141812d45f9d331b5b6359106e7ce376b57a`

셸 문법 검사(`sh -n`)는 `install.sh`와 두 `doctor.sh` 모두 통과했다. 스크립트 실행 자체와 외부 출처의 commit 재검증은 이번 요청 범위에 포함하지 않아 수행하지 않았다.

## 8. 적용 시 주의점

- 설치 ZIP은 프로젝트 내부 자료가 아니라 사용자 전역 Codex 환경을 바꾸는 설치물이다. 사용자가 별도로 설치를 승인하기 전에는 실행하지 않는다.
- `frontend-design`의 여덟 anchor 선택 규칙은 기존 제품의 시각 언어와 명시적 사용자 요구보다 우선하지 않는다. 오케스트레이터 자체도 사용자 요구·안전·기존 동작·접근성을 더 높은 우선순위로 둔다.
- `accessibility` 문서의 “disabled 상태를 피하라”와 같은 강한 문구는 제품 상태 모델·네이티브 컨트롤 의미·접근성 요구를 함께 검토해 적용해야 한다.
- 이 프로젝트의 상위 `AGENTS.md` 규칙에 따라 VoiceOver 검증은 이후 웹앱 작업에서도 수행하지 않는다. 첨부 문서의 일반적인 screen-reader 수동 검토 문구와 충돌할 경우 프로젝트 상위 지침이 우선한다.

## 9. 현재 결론

자료는 프로젝트 내부에 보존 복사 및 압축 해제되었고, 단독 스킬 번들과 글로벌 설치 번들의 역할이 확인되었다. 현재 프로젝트에는 앱 소스나 실행할 웹 페이지가 없으므로, 이 turn에서는 구현·정적 검사·Playwright QA·전역 설치를 완료했다고 주장할 근거가 없다.
