# Completion Report Format

Use this structure, omitting only sections that are truly inapplicable.

```markdown
## Implementation summary
- What changed
- What behavior was preserved

## Design direction
- Existing system or selected anchor
- Reason
- Visible differentiator
- Palette, typography, structure, texture, and motion boundaries

## Design-system changes
- Reused and added tokens
- Reused, extended, added, or removed components
- Responsive relationships and interaction states

## Accessibility
- Semantic structure
- Keyboard and focus behavior
- Forms and status messaging
- Contrast, reflow, motion, and non-color cues
- Manual review still required

## Static verification
- Format: pass / fail / not available
- Lint: pass / fail / not available
- Typecheck: pass / fail / not available
- Tests: pass / fail / not available
- Build: pass / fail / not available

## Browser QA
- URL or route tested
- Desktop 1440x900: result
- Tablet 768x1024: result
- Mobile 390x844: result
- Primary flow exercised
- Console and resource findings

## Changed files
- path — purpose

## Remaining findings
- Severity — issue — next action

## Environment limitations
- Checks that could not run and why
```

Do not use “pass” for a check that was inferred rather than executed.
