# Privacy Policy — Grill

_Last updated: 2026-05-20_

Grill is a local Claude Code plugin that runs multi-agent codebase interrogation. This policy describes the data Grill handles.

## What Grill reads

The contents of files in the codebase you point it at, when you run `/grill:roast`. Six analysis agents (recon, architecture, error-handling, security, testing, edge-cases) run in parallel via Claude Code's Task tool, each reading the same codebase.

## What Grill writes

**Nothing persistent.** All findings are returned to your conversation. Grill does not write reports to disk unless you explicitly direct Claude Code to do so.

## What Grill transmits

**Nothing of its own.** Grill does not maintain a backend, does not phone home, does not collect telemetry, does not register usage with any third party.

Codebase contents are sent to Anthropic's API **by Claude Code itself** when the analysis agents run — under Anthropic's privacy terms, using your own credentials. Grill is not in that path.

## Third parties

None.

## Data deletion

There is no centralized data to retain or delete. To remove the plugin: `claude plugin uninstall grill@xiaolai`.

## Contact

For privacy questions or to report a discrepancy with this policy: **xiaolaiapple@gmail.com**.
