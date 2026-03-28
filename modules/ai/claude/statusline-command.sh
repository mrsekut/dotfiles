#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

# Parse fields from stdin JSON
MODEL_ID=$(echo "$INPUT" | jq -r '.model.id // ""')
MODEL_DISPLAY=$(echo "$INPUT" | jq -r '.model.display_name // "Unknown"')
CTX_PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

FIVE_HOUR_PCT=$(echo "$INPUT" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_HOUR_RESETS=$(echo "$INPUT" | jq -r '.rate_limits.five_hour.resets_at // empty')

# Git branch
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null || echo "?")

# True color ANSI
C_GREEN=$'\033[38;2;151;201;195m'
C_YELLOW=$'\033[38;2;229;192;123m'
C_RED=$'\033[38;2;224;108;117m'
C_GREY=$'\033[38;2;74;88;92m'
C_RESET=$'\033[0m'

color_for_pct() {
  local pct=${1:-0}
  if (( pct >= 80 )); then printf '%s' "$C_RED"
  elif (( pct >= 50 )); then printf '%s' "$C_YELLOW"
  else printf '%s' "$C_GREEN"
  fi
}

progress_bar() {
  local pct=${1:-0}
  local filled=$(( (pct + 5) / 10 ))
  (( filled > 10 )) && filled=10
  (( filled < 0 )) && filled=0
  local empty=$(( 10 - filled ))
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="▰"; done
  for ((i=0; i<empty; i++)); do bar+="▱"; done
  printf '%s' "$bar"
}

# Model name: claude-opus-4-6 -> Opus 4.6
if [[ "$MODEL_ID" =~ claude-([a-z]+)-([0-9]+)-([0-9]+) ]]; then
  NAME="${BASH_REMATCH[1]}"
  NAME="$(tr '[:lower:]' '[:upper:]' <<< "${NAME:0:1}")${NAME:1}"
  MODEL_NAME="$NAME ${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
else
  MODEL_NAME="$MODEL_DISPLAY"
fi

# --- Single line: model │ branch │ ctx │ 5h rate limit ---
SEP="${C_GREY}│${C_RESET}"
CTX_INT=${CTX_PCT%%.*}
CTX_C=$(color_for_pct "$CTX_INT")

RATE_PART=""
if [[ -n "$FIVE_HOUR_PCT" ]]; then
  PCT_INT=${FIVE_HOUR_PCT%%.*}
  FC=$(color_for_pct "$PCT_INT")
  BAR=$(progress_bar "$PCT_INT")

  RESET_STR=""
  if [[ -n "$FIVE_HOUR_RESETS" ]]; then
    RESET_STR=$(TZ=Asia/Tokyo date -r "$FIVE_HOUR_RESETS" "+%-I%p" 2>/dev/null || echo "")
    [[ -n "$RESET_STR" ]] && RESET_STR="  Resets ${RESET_STR}"
  fi

  printf -v RATE_PART ' %s 5h %s%s %s%%%s%s' "$SEP" "$FC" "$BAR" "$PCT_INT" "$C_RESET" "$RESET_STR"
else
  printf -v RATE_PART ' %s 5h %s▱▱▱▱▱▱▱▱▱▱ --%% %s' "$SEP" "$C_GREY" "$C_RESET"
fi

printf '%s%s%s %s %s%s%s %s ctx %s%s%%%s%s\n' \
  "$C_GREEN" "$MODEL_NAME" "$C_RESET" "$SEP" \
  "$C_GREEN" "$BRANCH" "$C_RESET" "$SEP" \
  "$CTX_C" "$CTX_PCT" "$C_RESET" "$RATE_PART"
