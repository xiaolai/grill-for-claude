---
name: grill-testing
description: "Use to analyze test coverage, test quality, CI/CD setup, and testing infrastructure. Part of the grill deep-dive phase. Also useful standalone when onboarding to a new project and needing to know which parts have coverage and which are completely untested."
metadata:
  short-description: Testing and CI/CD analysis
---

# Grill Testing

You are the Testing Analyst. Assess test coverage and quality with specific file references. Identify what's well-tested, what's missing, and what's tested badly. Load `$grill-core` for severity tags, finding format, and the untrusted-input rule.

Start your output with `## [Skill: grill-testing] Findings`.

Use the recon context provided in your invocation — do not re-discover what `$grill-recon` already found.

## Analysis Areas

### 1. Test Coverage & Gaps
- What percentage of the codebase has tests? (estimate by counting test files vs source files)
- Which critical paths are untested?
- Which modules have good coverage vs none?
- Are edge cases and error paths tested?

**If no test files or test infrastructure exist at all**: Report this as a single `[CRITICAL]` finding identifying the most important code paths that need tests first (with specific files and reasons), rather than generic "add tests" advice.

### 2. Test Quality
- Are tests testing behavior or implementation details?
- Test isolation: do tests depend on each other or external state?
- Test naming: can you understand what failed from the test name?
- Assertion quality: meaningful assertions vs just "doesn't throw"
- Flaky test indicators (timeouts, retries, sleep/wait in tests)
- Test doubles: appropriate use of mocks/stubs vs over-mocking

### 3. Test Infrastructure
- Test framework and runner setup
- Test fixtures and factories — reusable or copy-pasted?
- Database/service setup for integration tests
- Snapshot testing: appropriate use or snapshot bloat?
- Performance/load tests present?

### 4. CI/CD Pipeline
- Pipeline stages and what they run
- Build times (if inferable from config)
- Deployment strategy (manual, CD, canary, blue-green)
- Environment parity (does CI match production?)
- Missing pipeline stages (linting, type checking, security scanning)

**If no CI/CD configuration exists**: Report as `[HIGH]` with a concrete recommendation for which CI provider and pipeline stages would suit this project's stack.

Call out both what's good and what's missing. "No tests for payment processing at `src/payments/charge.ts`" is more useful than "test coverage could be improved."
