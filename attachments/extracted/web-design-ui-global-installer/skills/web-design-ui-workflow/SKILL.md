---
name: web-design-ui-workflow
description: Orchestrate an end-to-end web UI workflow by applying the globally installed frontend-design, frontend-ui-standards, and accessibility skills, then validating the result with Playwright MCP. Use for creating, restyling, refactoring, reviewing, or debugging user-facing web pages, web apps, landing pages, responsive layouts, design systems, components, forms, navigation, and interaction flows when visual direction, reusable implementation, accessibility, and real-browser QA must be handled together.
---

# Web Design UI Workflow

Use this skill as the control plane for web-interface work. Do not replace or paraphrase the child skills when they are available; activate them at the required phase and preserve their distinct responsibilities.
Invoke each child by its `$skill-name` when the client exposes nested skill activation. If nested activation is not available, read the corresponding `SKILL.md` directly and follow it as that phase's authoritative instructions.

## Required dependencies

Require all of the following global dependencies before implementation:

- `$frontend-design` at `$CODEX_HOME/skills/frontend-design/SKILL.md` for art direction and content discipline.
- `$frontend-ui-standards` at `$CODEX_HOME/skills/frontend-ui-standards/SKILL.md` for tokens, metrics, reusable components, and layout consistency.
- `$accessibility` at `$CODEX_HOME/skills/accessibility/SKILL.md` for semantic structure, keyboard use, focus, forms, contrast, motion, and documented manual checks.
- Playwright MCP server named `playwright` for real-browser interaction and verification.

Resolve `$CODEX_HOME` to `~/.codex` when it is unset. If any dependency is unavailable, run `scripts/doctor.sh`, report the missing item, and stop before claiming the complete workflow ran. Do not silently substitute an invented copy of a missing child skill.

## Operating rules

1. Preserve explicit user requirements, existing behavior, data safety, and project conventions.
2. Inspect the current codebase before proposing a new design system or component.
3. Never fabricate product data, customers, telemetry, metrics, or testimonials to make a screen look complete.
4. Avoid framework replacement, broad dependency churn, and unrelated refactors unless the task requires them.
5. Treat accessibility as a design and implementation input, not a final cosmetic audit.
6. Use Playwright only against the intended development or test target. Do not reuse personal browser profiles or authenticated sessions unless the user explicitly requests it.
7. Limit the automated fix-and-retest loop to three rounds. Report unresolved issues honestly.
8. Do not mark manual accessibility checks as passed merely because automated browser checks succeeded.

## Mandatory workflow

Follow the complete sequence below unless the user explicitly limits the scope.

### 1. Inspect and classify

Determine whether the task is creation, restyling, refactoring, review, or bug fixing. Inspect:

- framework, package scripts, routes, and development-server command;
- existing design tokens, theme files, component libraries, and shared layouts;
- current Git status without resetting, stashing, or overwriting user changes;
- primary user flows and behavior that must remain intact;
- supplied references, screenshots, content, and constraints.

Read `references/workflow.md` for the full discovery and branching procedure.

### 2. Apply `$frontend-design`

Activate the child skill before writing visible UI code. Produce a concise design contract containing:

- problem and audience;
- one visual anchor and the reason for choosing it;
- one visible differentiator;
- palette, typography, structure, texture, and motion boundaries;
- content rules and prohibited fabrication.

Use the project's established visual language when the task is a contained change inside an existing product. Do not force a new anchor over a mature design system unless the user requested a redesign.

### 3. Apply `$frontend-ui-standards`

Activate the child skill and translate the design contract into an implementation contract:

- existing tokens to reuse and semantic tokens to add;
- components and variants to reuse, extend, or create;
- global, component-specific, and screen-specific metrics;
- responsive relationships rather than isolated pixel nudges;
- loading, empty, error, disabled, hover, focus, and active states.

Prefer a shared component or variant over a second local implementation of the same visual role.

### 4. Apply `$accessibility`

Activate the child skill before finalizing markup or interaction design. Define:

- semantic elements, landmarks, headings, labels, and accessible names;
- keyboard interaction and visible-focus behavior;
- form instructions, validation, and error announcement;
- dialog, menu, disclosure, carousel, or custom-widget focus behavior;
- contrast, zoom/reflow, reduced-motion, touch-target, and non-color cues;
- checks that require human review.

When aesthetic direction conflicts with accessibility, preserve the direction while changing tokens or interaction details enough to meet the accessibility requirement. Accessibility takes priority over decoration.

### 5. Implement minimally and systematically

Implement the smallest coherent change that satisfies all three contracts. Preserve behavior and reuse local patterns. Keep design math in tokens or named metrics, not scattered through view code.

### 6. Run static project checks

Run only checks supported by the project, such as format, lint, typecheck, unit tests, and production build. Fix blocking failures introduced by the change before browser QA. Distinguish pre-existing failures from new failures.

### 7. Validate with Playwright MCP

Use the `playwright` MCP server against the running development or test build. Verify the default viewports unless project requirements specify others:

- desktop: `1440x900`;
- tablet: `768x1024`;
- mobile: `390x844`.

Exercise the primary user flow, not only the initial page. Inspect layout, text wrapping, overflow, navigation, controls, forms, state changes, console errors, and failed resources. Then perform keyboard and accessibility-tree checks.

Read `references/playwright-qa.md` before browser validation.

### 8. Enforce quality gates and iterate

Classify findings using `references/quality-gates.md`. For each fix round:

1. group findings by root cause;
2. make the smallest systematic fix;
3. rerun affected static checks;
4. retest affected viewports and flows;
5. stop after three rounds or when all blocking issues are resolved.

Never hide a blocker by weakening a test, removing a focus outline, clipping content, disabling validation, or bypassing an interaction.

### 9. Report evidence

Use `references/report-format.md`. Include design decisions, system changes, accessibility checks, static-check results, browser viewports and flows tested, changed files, unresolved findings, and manual-review items. State explicitly when Playwright or another dependency could not run.

## Conflict priority

Resolve conflicts in this order:

1. user data and operational safety;
2. explicit user requirements and existing product behavior;
3. accessibility and usable interaction;
4. the project's established design system;
5. reusable component and token discipline;
6. selected visual direction;
7. decorative motion and polish.

## Scope shortcuts

- For **review-only** work, run discovery, activate all relevant child skills, execute available checks, and report findings without editing unless asked.
- For **small visual bugs**, retain the existing art direction, use `$frontend-ui-standards` to find the systemic cause, apply `$accessibility`, and retest affected breakpoints.
- For **new landing pages or substantial redesigns**, run every phase and make the visual direction explicit before implementation.
- For **non-web native UI**, use `$frontend-ui-standards` directly rather than this workflow unless Playwright-based web validation still applies.
