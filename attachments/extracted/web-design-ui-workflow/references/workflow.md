# Workflow

## Contents

1. Entry decision
2. Discovery
3. Design contract
4. Implementation contract
5. Accessibility contract
6. Implementation and static checks
7. Browser QA
8. Iteration and completion

## 1. Entry decision

Classify the request:

- **Create**: a new page, flow, component family, or design system.
- **Restyle**: visual direction changes while core behavior remains.
- **Refactor**: consolidate tokens, metrics, or duplicated components.
- **Repair**: fix layout, responsive, interaction, or accessibility defects.
- **Review**: inspect and report without changing files unless requested.

For an existing product, first decide whether the requested change is local or system-wide. A local change must not introduce a competing visual language.

## 2. Discovery

Inspect only what is needed to understand the interface and its execution path:

- package manager and scripts;
- application entry points and routes;
- CSS/theme/token files;
- shared component directories;
- closest existing screen or component;
- test setup and browser-test setup;
- development URL and required environment variables;
- Git status and uncommitted user work.

Record assumptions. Do not invent missing product facts. Ask only when a missing decision would materially change the implementation and cannot be inferred from the code or request.

## 3. Design contract

Activate `$frontend-design`. For a new or substantially redesigned surface, capture:

```text
Problem:
Audience:
Anchor:
Why this anchor:
Visible differentiator:
Palette:
Typography:
Structure:
Texture and motion:
Content rules:
```

For a mature existing system, describe the current direction instead of imposing a new anchor. Use the child skill's content discipline in all cases.

## 4. Implementation contract

Activate `$frontend-ui-standards`. Map the design contract to:

```text
Existing tokens to reuse:
New semantic tokens:
Existing components to reuse:
Variants to add:
New components and why variants are insufficient:
Global metrics:
Component metrics:
Screen metrics:
Responsive relationships:
Interaction states:
```

Search the codebase before adding each shared visual role. Prefer derived relationships and shared containers over coordinate copies.

## 5. Accessibility contract

Activate `$accessibility`. Record:

```text
Landmarks and headings:
Native controls:
Accessible names and descriptions:
Keyboard model:
Focus entry, containment, and return:
Form errors and status messaging:
Contrast and non-color cues:
Zoom/reflow and reduced motion:
Manual review requirements:
```

Do not use ARIA to imitate semantics already available through native HTML.

## 6. Implementation and static checks

Implement in this order:

1. semantic structure and behavior;
2. shared tokens and components;
3. responsive layout;
4. states and validation;
5. visual polish and motion.

Run available checks in the project's normal order. A common sequence is format, lint, typecheck, test, build. Do not add a new checker solely to make the workflow appear complete unless the project needs it and the change is justified.

## 7. Browser QA

Start the normal development or preview server. Use Playwright MCP to:

1. open the intended route;
2. test the primary flow at desktop width;
3. repeat relevant steps at tablet and mobile widths;
4. inspect console and resource failures;
5. test keyboard-only operation;
6. inspect semantic structure and accessible names;
7. capture evidence when useful;
8. close the isolated browser context when finished.

## 8. Iteration and completion

Perform at most three fix rounds. A round should address root causes rather than individual screenshots. Rerun all checks affected by the change.

Completion requires either:

- no blocking findings and a clear record of tests performed; or
- an honest partial-completion report that names blockers, environment limitations, and remaining manual work.
