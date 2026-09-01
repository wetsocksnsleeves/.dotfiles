#!/usr/bin/env bash
# Poll a URL until the app answers, after a branch switch / restart.
# Usage: wait_for_app.sh <url> [timeout_seconds]
set -uo pipefail

URL="${1:?usage: wait_for_app.sh <url> [timeout_seconds]}"
TIMEOUT="${2:-180}"
DEADLINE=$(( $(date +%s) + TIMEOUT ))

while [ "$(date +%s)" -lt "$DEADLINE" ]; do
  CODE="$(curl -k -s -o /dev/null -m 10 -w '%{http_code}' "$URL" || echo 000)"
  case "$CODE" in
    200|301|302|303|401|403)
      echo "up (HTTP $CODE) after $(( TIMEOUT - (DEADLINE - $(date +%s)) ))s"
      exit 0
      ;;
  esac
  printf '.' >&2
  sleep 3
done

echo "TIMEOUT after ${TIMEOUT}s (last HTTP ${CODE:-none})" >&2
exit 1
