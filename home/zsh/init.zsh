### Completion
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*' \
  'r:|?=**'

### KeyBind
# Base config
autoload -Uz select-word-style
select-word-style bash

# History
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# Ctrl-Y
cd-up() {
  BUFFER="cd ../"
  zle accept-line
}
zle -N cd-up
bindkey '^Y' cd-up
