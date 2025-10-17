#!/bin/sh

# -- CONFIGURATION --
BW_BIN="./bw"                # Path to your Bitwarden CLI binary
SESSION_TTL=600              # Time in seconds (10 minutes)

# -- LOG IN / UNLOCK --
echo "🔐 Logging into Bitwarden..."

# Start login if not already logged in
if ! $BW_BIN status | grep -q '"status": "unauthenticated"'; then
  $BW_BIN login
fi

# Unlock and store session token (use --raw to avoid caching to disk)
export BW_SESSION=$($BW_BIN unlock --raw)

# Check success
if [ -z "$BW_SESSION" ]; then
  echo "❌ Failed to unlock Bitwarden."
  exit 1
fi

echo "✅ Session started. It will expire in $((SESSION_TTL/60)) minutes."

# -- SESSION TIMER --
(
  sleep "$SESSION_TTL"
  echo "⏳ Bitwarden session expired after $SESSION_TTL seconds."
  unset BW_SESSION
  kill $$ 2>/dev/null
) &

TIMER_PID=$!

# -- TEMPORARY SUBSHELL --
trap 'unset BW_SESSION; kill $TIMER_PID 2>/dev/null; echo "🧼 Session cleaned up."; exit' INT TERM EXIT
/bin/sh

# Cleanup (in case user exits manually)
unset BW_SESSION
kill $TIMER_PID 2>/dev/null
echo "👋 Bitwarden session closed."
