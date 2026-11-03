function ssh --wraps=ssh
  # change bg color (dark red)
  printf '\033]11;#140000\a'

  # execute SSH
  command ssh $argv
  set -l st $status

  # reset to original bg, even when SSH fails or is interrupted
  printf '\033]111\a'
  return $st
end
