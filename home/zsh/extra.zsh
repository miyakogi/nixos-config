### autocmd
chpwd() {
  [[ $PWD != $OLDPWD ]] && ls
}

# Ctrl-J
__zoxide_zi_widget() {
  __zoxide_zi ""
  local success=$?
  zle redisplay
  (( $success != 0 )) && return
  BUFFER="ls"
  zle accept-line
}
zle -N __zoxide_zi_widget
bindkey '^J' __zoxide_zi_widget

### function
tree() {
  ls --tree 2>/dev/null || command tree
}

# Load Plugins
if [ -f "$HOME/bin/done-shared.sh" ]; then
  source "$HOME/bin/done-shared.sh"
fi

# Override Atuin strategy to prefer current directory (fish-like)
_zsh_autosuggest_strategy_atuin() {
  suggestion=$(
    ATUIN_QUERY="$1" \
    atuin search --cmd-only --limit 1 \
      --search-mode prefix \
      --filter-mode directory \
      2>/dev/null
  )
}

if [[ ! -o login ]]; then
  if command -v fastfetch &>/dev/null; then
    fastfetch --config config-short.jsonc
  elif command -v macchina &>/dev/null; then
    macchina
  fi
fi
