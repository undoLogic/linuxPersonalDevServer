#!/bin/sh

# -- CONFIGURATION --
BW_BIN="./bw"                 # Adjust path to CLI binary if needed
SESSION_TTL=600               # Vault unlock time (in seconds)

# -- LOGIN (Only If Needed) --
if $BW_BIN status | grep -q '"status": "unauthenticated"'; then
  echo "🔐 Logging in to Bitwarden..."
  $BW_BIN login || { echo "❌ Login failed"; exit 1; }
fi

# -- UNLOCK VAULT --
export BW_SESSION=$($BW_BIN unlock --raw)
if [ -z "$BW_SESSION" ]; then
  echo "❌ Failed to unlock Bitwarden"
  exit 1
fi

echo "✅ Vault unlocked for $((SESSION_TTL / 60)) minutes."

# -- AUTO-LOCK AFTER TIMEOUT --
(
  sleep "$SESSION_TTL"
  $BW_BIN lock
  echo "🔒 Vault auto-locked after timeout."
  kill $$ 2>/dev/null
) &
TIMER_PID=$!

# -- INTERACTIVE SHELL WITH SESSION --
trap 'unset BW_SESSION; kill $TIMER_PID 2>/dev/null; echo "👋 Exiting secure shell."; exit' INT TERM EXIT
/bin/sh

# -- AFTER EXIT --
unset BW_SESSION
kill $TIMER_PID 2>/dev/null
