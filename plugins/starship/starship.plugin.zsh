if (( $+commands[starship] )); then
  # ignore ry-zsh theme
  unset ZSH_THEME

  eval "$(starship init zsh)"
else
  echo '[ry-zsh] starship not found, please install it from https://starship.rs'
fi
