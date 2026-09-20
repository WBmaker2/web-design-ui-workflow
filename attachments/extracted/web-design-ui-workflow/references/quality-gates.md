# Quality Gates

## Blocking

Do not report the workflow as complete while any introduced blocker remains:

- application or production build fails;
- primary user flow cannot be completed;
- uncaught runtime error appears in the tested flow;
- key button, link, form, navigation, or dialog does not work;
- required content is inaccessible at a supported viewport;
- horizontal overflow hides primary content or controls;
- interactive elements have no accessible name;
- keyboard trap or unreachable essential control exists;
- visible focus is removed or unusable;
- dialog focus entry, containment, or return is broken;
- form errors are communicated only through color or are not associated with fields;
- sensitive data is exposed in logs, screenshots, test fixtures, or browser state.

## Major

Fix before completion when caused by the change; otherwise document with ownership:

- repeated layout breakage at a default viewport;
- major content clipping or unreadable wrapping;
- inconsistent component implementation that will cause product drift;
- missing loading, empty, error, or retry state for a core interaction;
- serious contrast, zoom/reflow, reduced-motion, or touch-target issue;
- repeated console errors or failed essential resources.

## Minor

Fix when low risk, or document:

- small spacing inconsistency;
- nonessential decorative mismatch;
- isolated low-impact wrapping issue outside core content;
- pre-existing warning unrelated to the change;
- polish issue that does not impair understanding or operation.

## Manual review

Never convert these into automated passes without evidence:

- screen-reader reading order and announcement quality;
- usability at high zoom and operating-system high-contrast modes;
- cognitive clarity of complex instructions or long forms;
- appropriateness of alternative text for domain-specific imagery;
- usefulness of captions, transcripts, and live-region announcements;
- testing with users with disabilities.

## Environment limitation

Use this classification when a required dependency, credential, service, browser, fixture, or platform is unavailable. State exactly which checks did not run and avoid implying success.
