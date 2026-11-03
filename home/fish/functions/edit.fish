function edit --description 'Open file with default editor'
  if test -z "$EDITOR"
    echo 'EDITOR is not set' >&2
    return 1
  end
  $EDITOR $argv
end
