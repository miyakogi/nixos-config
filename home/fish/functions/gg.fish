#!/usr/bin/env fish

function gg
  if git rev-parse --is-inside-work-tree &>/dev/null
    cd (git rev-parse --show-toplevel)
  else
    cd ~
  end
end
