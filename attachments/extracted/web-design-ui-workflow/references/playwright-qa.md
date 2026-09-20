# Playwright MCP QA

## Safety and setup

Use the MCP server named `playwright`. The global configuration is expected to use a pinned package version, headless mode, an isolated in-memory browser profile, and WebMCP collection disabled.

- Open only the intended local, preview, or test URL.
- Do not use a personal profile or persisted authentication by default.
- Do not enter real secrets into an untrusted page.
- Do not broaden file access or network access merely to bypass a test failure.
- If authentication is required, use approved test credentials or a user-provided storage state.

## Default viewport matrix

| Target | Width | Height |
|---|---:|---:|
| Desktop | 1440 | 900 |
| Tablet | 768 | 1024 |
| Mobile | 390 | 844 |

Add project-specific breakpoints when the product explicitly supports them. Test orientation changes when layout behavior depends on orientation.

## Visual and responsive checks

At each relevant viewport, inspect:

- unintended horizontal scrolling;
- clipped, overlapping, or off-screen content;
- text wrapping, truncation, and minimum readable size;
- sticky and fixed elements covering content;
- navigation collapse and menu dismissal;
- image and icon loading;
- component alignment and spacing rhythm;
- hover, active, focus-visible, selected, loading, disabled, empty, error, and success states;
- safe-area and virtual-keyboard behavior when applicable.

## Functional checks

Exercise the main user path. Include meaningful state changes such as:

- opening and closing navigation;
- entering, validating, and submitting a form;
- filtering or sorting data;
- opening a dialog, sheet, disclosure, or menu;
- navigating to a detail view and returning;
- retrying after an error;
- completing the primary call to action.

Do not claim a control works based only on its appearance.

## Accessibility checks

Use snapshots and keyboard actions to verify:

- one meaningful page title and logical heading structure;
- landmarks and navigation labels;
- accessible names for links, buttons, form controls, and icon-only controls;
- logical Tab order aligned with visual order;
- visible focus at every stop;
- activation with Enter or Space where expected;
- arrow-key behavior for widgets that require it;
- no keyboard trap;
- dialog focus entry and return;
- error text and status announcements represented in the accessibility tree;
- important meaning not conveyed only by color.

Record screen-reader, high-contrast, and real-user checks as manual review unless they were genuinely performed.

## Console and network evidence

Inspect console errors and failed resources during the tested flow. Distinguish:

- failures introduced by the change;
- pre-existing application failures;
- expected development warnings;
- third-party or environment failures.

## Retest rule

After a fix, retest the affected flow and viewport plus any shared component surface that may inherit the change. Rerun a broader matrix when the fix touches global tokens, layout primitives, routing, or shared interaction code.
