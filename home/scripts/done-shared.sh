# shellcheck shell=bash
# done-shared.sh — zsh/bash shared long-command notifier
# Threshold 5s, focus-aware (Hyprland address / Niri id).

# Prevent double load
if [ "${__done_shared_loaded:-}" != "" ]; then
  return 0 2>/dev/null || exit 0
fi
__done_shared_loaded=1

: "${DONE_MIN_CMD_DURATION:=5}"

# Early dependency check (once)
if ! command -v jq >/dev/null 2>&1; then
  echo >&2 "[done-shared] jq not found, notification disabled"
  return 0 2>/dev/null || exit 0
fi
if ! command -v notify-send >/dev/null 2>&1; then
  echo >&2 "[done-shared] notify-send not found, notification disabled"
  return 0 2>/dev/null || exit 0
fi

# zsh: EPOCHSECONDS requires zsh/datetime
if [ "${ZSH_VERSION:-}" != "" ]; then
  zmodload zsh/datetime 2>/dev/null || true
fi

__done_initial_window_id=""
__done_start_time="${EPOCHSECONDS:-$SECONDS}"
__done_last_command=""

__done_get_focused_window_id() {
  if [ "${HYPRLAND_INSTANCE_SIGNATURE:-}" != "" ] && command -v hyprctl >/dev/null 2>&1; then
    hyprctl activewindow -j 2>/dev/null | jq -r '.address // empty' 2>/dev/null
    return
  fi
  if [ "${NIRI_SOCKET:-}" != "" ] && command -v niri >/dev/null 2>&1; then
    niri msg --json focused-window 2>/dev/null | jq -r '.id // empty' 2>/dev/null
    return
  fi
}

__done_humanize_duration() {
  local total=$1
  local hours=$(( total / 3600 ))
  local minutes=$(( (total % 3600) / 60 ))
  local seconds=$(( total % 60 ))
  if [ "$hours" -gt 0 ]; then
    printf '%sh ' "$hours"
  fi
  if [ "$minutes" -gt 0 ]; then
    printf '%sm ' "$minutes"
  fi
  if [ "$seconds" -gt 0 ] || [ "$total" -eq 0 ]; then
    printf '%ss' "$seconds"
  fi
}

# preexec: record time, command, and initial focused window id
__done_preexec() {
  case "${1:-${BASH_COMMAND:-}}" in
    __done_*|*__done_precmd*|*__done_preexec*) return 0 ;;
  esac
  __done_last_command="${1:-${BASH_COMMAND:-}}"
  __done_start_time="${EPOCHSECONDS:-$SECONDS}"
  __done_initial_window_id=$(__done_get_focused_window_id)
}

# precmd: threshold check first; then compare current window with initial
__done_precmd() {
  local exit_status=$?
  # No command has run yet (startup precmd) → skip
  [ "$__done_last_command" = "" ] && return 0
  local end_time="${EPOCHSECONDS:-$SECONDS}"
  local elapsed=$(( end_time - __done_start_time ))
  [ "$elapsed" -lt "${DONE_MIN_CMD_DURATION:-5}" ] && return 0

  # --- Only here (>=threshold) do we potentially run external commands ---
  local current
  current=$(__done_get_focused_window_id)

  # Compare with initial window id (captured at preexec)
  if [ "$current" != "" ] && [ "$current" = "$__done_initial_window_id" ]; then
    return 0  # same window → focused → suppress
  fi

  # Not focused → notify
  local title message urgency="normal"
  [ "$exit_status" -ne 0 ] && urgency="critical"
  if [ "$exit_status" -ne 0 ]; then
    title="Failed ($exit_status) after $(__done_humanize_duration "$elapsed")"
  else
    title="Done in $(__done_humanize_duration "$elapsed")"
  fi
  message=$(printf '%s' "${__done_last_command:-Command finished}" | head -c 300)
  notify-send --hint=int:transient:1 --urgency="$urgency" --icon=utilities-terminal \
    --app-name="${ZSH_NAME:-bash}" --expire-time=10000 -- "$title" "$message" 2>/dev/null || true

  return "$exit_status"
}

# Hook registration per shell
if [ "${ZSH_VERSION:-}" != "" ]; then
  autoload -U add-zsh-hook 2>/dev/null || true
  add-zsh-hook preexec __done_preexec 2>/dev/null || true
  add-zsh-hook precmd __done_precmd 2>/dev/null || true
elif [ "${BLE_VERSION:-}" != "" ]; then
  blehook PREEXEC+=__done_preexec 2>/dev/null || true
  blehook POSTEXEC+=__done_precmd 2>/dev/null || true
elif [ "${BASH_VERSION:-}" != "" ]; then
  # Plain bash: use DEBUG trap + PROMPT_COMMAND
  if [[ "$PROMPT_COMMAND" != *"__done_precmd"* ]]; then
    trap '__done_preexec "$BASH_COMMAND"' DEBUG 2>/dev/null || true
    PROMPT_COMMAND="__done_precmd${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
  fi
fi
