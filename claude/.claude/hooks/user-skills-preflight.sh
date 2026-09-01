#!/bin/bash
# UserPromptSubmit hook - adds user-level skills (~/.claude/skills) to the forced
# pre-flight Skill Check. The project hook at
# .claude/hooks/skill-forced-eval-hook.sh only scans $CLAUDE_PROJECT_DIR/.claude/skills,
# so user-level skills never appear in its list.
# Opt-out: set DISABLE_SKILL_HOOK=1 to deactivate.

[ "$DISABLE_SKILL_HOOK" = "1" ] && exit 0

USER_SKILLS_DIR="$HOME/.claude/skills"
[ -d "$USER_SKILLS_DIR" ] || exit 0

LIST=""
ALWAYS=""

for skill_dir in "$USER_SKILLS_DIR"/*; do
  [ -d "$skill_dir" ] || continue
  skill_md="$skill_dir/SKILL.md"
  [ -f "$skill_md" ] || continue
  grep -q '^disable-model-invocation: true' "$skill_md" && continue

  name=$(basename "$skill_dir")
  desc=$(grep -m1 '^description:' "$skill_md" | sed 's/^description:[[:space:]]*//')
  short=$(printf '%s' "$desc" | cut -c1-160 | sed 's/\.[^.]*$/./')

  LIST="$LIST
• $name - $short"

  case "$desc" in
    *[Aa]lways\ appl*|*[Aa]lways\ use*|*[Mm]ust\ always*) ALWAYS="$ALWAYS $name" ;;
  esac
done

[ -z "$LIST" ] && exit 0

cat <<EOF
ALSO IN SCOPE - user-level skills (~/.claude/skills)

The pre-flight list above covers project skills only. The skills below are also
available and count for the same Skill Check gate:
$LIST
EOF

if [ -n "$ALWAYS" ]; then
  cat <<EOF

MANDATORY THIS TURN:$ALWAYS
The description marks it always-apply. Call it with the Skill tool before you
write your reply. Naming it on the Skill Check line does not load it.
EOF
fi
