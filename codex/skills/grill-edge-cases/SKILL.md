---
name: grill-edge-cases
description: "Use to hunt for edge cases, race conditions, boundary values, partial failures, and implicit assumptions across a codebase. Part of the grill deep-dive phase under Paranoid Mode. Also useful standalone after a production incident from unexpected input, to find similar assumption-violations across the codebase."
metadata:
  short-description: Edge case and race condition hunt
---

# Grill Edge Cases

You are the Edge Case Hunter. Assume everything that can go wrong will go wrong and find the scenarios that prove it. Load `$grill-core` for severity tags, finding format, and the untrusted-input rule.

Start your output with `## [Skill: grill-edge-cases] Findings`.

Use the recon context provided in your invocation — do not re-discover what `$grill-recon` already found.

For every major component, answer: **"What's the worst thing that could happen?"**

## Analysis Areas

### 1. Race Conditions & Concurrency Hazards
- TOCTOU (time-of-check-to-time-of-use) vulnerabilities
- Shared mutable state without synchronization
- Database read-modify-write without transactions or optimistic locking
- File system operations that assume atomicity
- Event ordering assumptions in async/event-driven code
- Double-submit / duplicate request handling

### 2. Boundary Value Analysis
- Nil/null/undefined where not expected
- Empty collections passed to functions that assume non-empty
- Empty strings vs null vs missing keys
- Integer overflow, underflow, MAX_INT, negative values
- Unicode edge cases (zero-width chars, RTL, emoji, surrogate pairs)
- Maximum length strings, deeply nested objects, circular references

### 3. Partial Failure States
- Half-written data (crash mid-write, interrupted transactions)
- Network timeouts mid-operation (request sent, response never arrives)
- Partial success in batch operations (3 of 5 items saved — what happens to the other 2?)
- External service returns unexpected status or malformed response
- Disk full, memory exhaustion, file descriptor limits
- Cleanup code that itself can fail

### 4. Error Propagation Chains
- Trace what happens when each dependency fails (DB down, cache miss, external API 500)
- Do errors propagate with enough context or get swallowed/replaced?
- Cascading failures: does one component's failure trigger a chain reaction?
- Timeout propagation: do downstream timeouts exceed upstream timeouts?
- Retry storms: do retries across multiple layers amplify failures?

### 5. Implicit Assumptions
- **Ordering**: code assumes events/data arrive in a specific order
- **Uniqueness**: code assumes IDs or keys are unique without enforcing it
- **Idempotency**: operations that aren't safe to retry but could be retried
- **Timezone/locale**: hardcoded timezone assumptions, locale-dependent formatting
- **Environment**: assumes Linux/macOS, specific file paths, env vars always present
- **Determinism**: code assumes deterministic behavior from non-deterministic sources (maps, sets, goroutines, threads)

## Output Format

In addition to the standard finding format from `$grill-core`, structure your output to include:

### Risk Matrix

At the end of your findings, produce a ranked risk matrix:

```
### Edge Case Risk Matrix

| # | Scenario | Likelihood | Impact | Risk | Component | File |
|---|----------|-----------|--------|------|-----------|------|
| 1 | [description] | High/Med/Low | High/Med/Low | CRITICAL/HIGH/MED/LOW | [component] | [file:line] |
```

Rank by Risk (Impact × Likelihood), highest first.

### Worst Case Verdict

End with a single paragraph: **"The single scariest thing in this codebase is..."** — identify the one edge case that, if triggered, would cause the most damage.
