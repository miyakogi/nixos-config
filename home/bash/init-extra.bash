# Runs after shellAliases (see bash.nix), so `ls` in function bodies expands
# to the eza alias at definition time.

# Functions used by both ble and non-ble shells
function edit() {
  "$EDITOR" "$@"
}

# fix helix cursor shape
function hx() {
  command hx "$@"
  printf '\033[0 q'
}

# go to git root
function gg() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    cd "$PWD"/"$(git rev-parse --show-cdup)" || return
  else
    cd || return
  fi
}

# change terminal bg color on ssh
function ssh() {
  # change bg color (dark red)
  printf '\033]11;#140000\a'

  # execute ssh
  command ssh "$@"

  # reset to original background
  printf '\033]111\a'
}

# execute `ls` on `cd`
function _auto_ls() {
  if [ "$PWD" != "$_LAST_PWD" ]; then
    if [ "$_LAST_PWD" != "" ]; then
      ls
    fi
    _LAST_PWD="$PWD"
  fi
}

# use eza for ls
function tree() {
  ls --tree 2>/dev/null || command tree
}

# Keybinds
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# ble.sh handles keys and hooks via ~/.blerc; plain bash uses readline
# bindings and PROMPT_COMMAND here instead.
if [[ -z ${BLE_VERSION-} ]]; then
  stty werase undef
  bind '"\C-w": unix-filename-rubout'
  PROMPT_COMMAND="_auto_ls${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

# Long command notifier (shared with zsh, Hyprland/Niri multi-window aware)
# Loads once per shell via guard in done-shared.sh
if [ -f "$HOME/bin/done-shared.sh" ]; then
  source "$HOME/bin/done-shared.sh"
fi

# Override Atuin source for ble.sh auto-complete (directory priority)
function ble/complete/auto-complete/source:atuin-history {
  local suggestion
  suggestion=$(
    atuin search --cmd-only --limit 1 \
      --search-mode prefix \
      --filter-mode directory \
      -- "$_ble_edit_str" 2>/dev/null
  )
  [[ $suggestion == "$_ble_edit_str"?* ]] || return 1
  ble/complete/auto-complete/enter h 0 \
    "${suggestion:${#_ble_edit_str}}" '' "$suggestion"
}

# startup
if ! shopt -q login_shell; then
  if command -v fastfetch &>/dev/null; then
    fastfetch --config config-short.jsonc
  elif command -v macchina &>/dev/null; then
    macchina
  fi
fi
