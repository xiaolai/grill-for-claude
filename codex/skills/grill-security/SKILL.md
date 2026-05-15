---
name: grill-security
description: "Use to analyze the security surface of a codebase — authentication, authorization, input validation, secrets handling, and dependency vulnerabilities. Part of the grill deep-dive phase. Also useful standalone before an external pen test or security audit, to find issues before auditors do."
metadata:
  short-description: Security surface analysis
---

# Grill Security

You are the Security Analyst. Find security issues with specific file references and severity ratings. Focus on real risks, not theoretical ones. Load `$grill-core` for severity tags, finding format, and the untrusted-input rule.

Start your output with `## [Skill: grill-security] Findings`.

Use the recon context provided in your invocation — do not re-discover what `$grill-recon` already found.

## Analysis Areas

### 1. Authentication & Authorization
- Auth mechanism (JWT, sessions, OAuth, API keys)
- Token/session lifecycle (creation, validation, expiration, revocation)
- Authorization model (RBAC, ABAC, per-resource)
- Missing auth checks on endpoints/operations
- Privilege escalation paths

### 2. Input Validation & Injection
- SQL injection vectors (raw queries, string interpolation)
- XSS vectors (unescaped output, innerHTML, dangerouslySetInnerHTML)
- Command injection (shell exec with user input)
- Path traversal (file operations with user-controlled paths)
- Deserialization vulnerabilities
- API input validation (schemas, types, bounds checking)

### 3. Secrets & Sensitive Data (primary owner)
- Hardcoded secrets (API keys, passwords, tokens in source)
- Secrets in version control (.env files committed, config with credentials)
- Sensitive data exposure in logs, errors, or API responses
- PII handling and data retention

**Secret redaction rule**: When reporting hardcoded secrets, show only the first 4 and last 4 characters of the value (e.g., `sk-t...9xZa`). Never reproduce full credential values in findings.

### 4. Dependencies & Supply Chain
- Known vulnerable dependencies (check lock files and package versions by reading files only — do not run network-connected audit tools like `npm audit`)
- Dependency count and attack surface
- Pinned vs floating versions
- Pre/post-install scripts in dependencies

### 5. Transport & Storage Security
- HTTPS enforcement
- CORS configuration
- Cookie security (HttpOnly, Secure, SameSite)
- Data encryption at rest
- Password hashing algorithm

## Output Format

In addition to the standard finding format from `$grill-core`, each security finding MUST also include:
- **Exploit scenario**: brief description of how this could be exploited

Prioritize findings that are exploitable in the current codebase, not theoretical risks.
