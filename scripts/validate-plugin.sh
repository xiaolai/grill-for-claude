#!/usr/bin/env bash
# Validates grill plugin structure: plugin.json, agent frontmatter, skill references.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

pass() { echo "  ✓ $1"; }
fail() { echo "  ✗ $1"; ERRORS=$((ERRORS + 1)); }
warn() { echo "  ⚠ $1"; WARNINGS=$((WARNINGS + 1)); }

echo "=== Grill Plugin Validator ==="
echo ""

# 1. Check plugin.json
echo "Checking plugin.json..."
MANIFEST="$PLUGIN_ROOT/.claude-plugin/plugin.json"
if [ ! -f "$MANIFEST" ]; then
  fail "Missing .claude-plugin/plugin.json"
else
  pass "plugin.json exists"
  # Validate JSON syntax
  if python3 -c "import json; json.load(open('$MANIFEST'))" 2>/dev/null; then
    pass "plugin.json is valid JSON"
  else
    fail "plugin.json is not valid JSON"
  fi
  # Check required fields
  for field in name version description; do
    if python3 -c "import json; d=json.load(open('$MANIFEST')); assert '$field' in d" 2>/dev/null; then
      pass "plugin.json has '$field' field"
    else
      fail "plugin.json missing '$field' field"
    fi
  done
fi

echo ""

# 2. Check commands
echo "Checking commands..."
for cmd in "$PLUGIN_ROOT"/commands/*.md; do
  [ -f "$cmd" ] || continue
  name=$(basename "$cmd")
  # Check frontmatter exists
  if head -1 "$cmd" | grep -q '^---$'; then
    pass "$name has frontmatter"
  else
    fail "$name missing frontmatter"
  fi
  # Check description field
  if grep -q '^description:' "$cmd"; then
    pass "$name has description"
  else
    fail "$name missing description"
  fi
done

echo ""

# 3. Check agents
echo "Checking agents..."
for agent in "$PLUGIN_ROOT"/agents/*.md; do
  [ -f "$agent" ] || continue
  name=$(basename "$agent")
  # Check frontmatter
  if head -1 "$agent" | grep -q '^---$'; then
    pass "$name has frontmatter"
  else
    fail "$name missing frontmatter"
    continue
  fi
  # Check required fields
  if grep -q '^description:' "$agent"; then
    pass "$name has description field"
  else
    fail "$name missing description field"
  fi
  if grep -q '^model:' "$agent"; then
    pass "$name has model field"
  else
    fail "$name missing model field"
  fi
  # Check skill references resolve
  skills=$(grep -A1 '^skills:' "$agent" 2>/dev/null | grep '^ *- ' | sed 's/^ *- //' || true)
  for skill_ref in $skills; do
    # skill_ref format: plugin-name:skill-name -> skills/skill-name/SKILL.md
    skill_name="${skill_ref#*:}"
    skill_path="$PLUGIN_ROOT/skills/$skill_name/SKILL.md"
    if [ -f "$skill_path" ]; then
      pass "$name → skill '$skill_ref' resolves to $skill_path"
    else
      fail "$name → skill '$skill_ref' does NOT resolve (expected $skill_path)"
    fi
  done
done

echo ""

# 4. Check skills
echo "Checking skills..."
for skill_dir in "$PLUGIN_ROOT"/skills/*/; do
  [ -d "$skill_dir" ] || continue
  name=$(basename "$skill_dir")
  if [ -f "$skill_dir/SKILL.md" ]; then
    pass "skills/$name/SKILL.md exists"
    if head -1 "$skill_dir/SKILL.md" | grep -q '^---$'; then
      pass "skills/$name/SKILL.md has frontmatter"
    else
      fail "skills/$name/SKILL.md missing frontmatter"
    fi
  else
    fail "skills/$name/ missing SKILL.md"
  fi
done

echo ""

# 5. Summary
echo "=== Results ==="
if [ $ERRORS -eq 0 ]; then
  echo "All checks passed! ($WARNINGS warnings)"
  exit 0
else
  echo "$ERRORS errors, $WARNINGS warnings"
  exit 1
fi
