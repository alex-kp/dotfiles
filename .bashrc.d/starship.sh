function set_win_title(){
  local current_dir="$PWD"
  local home_dir="$HOME"

  if [[ "$current_dir" == "$home_dir" ]]; then
    title="~"
  elif [[ "$current_dir" == "$home_dir"/* ]]; then
    title="~/${current_dir#"$home_dir/"}"
  else
    title="$current_dir"
  fi

  echo -ne "\033]0; ${USER}@${HOSTNAME}: ${title} \007"
  # echo -ne "\033]0; ${USER}@${HOSTNAME}: $(basename "$PWD") \007"
}
starship_precmd_user_func="set_win_title"
eval "$(starship init bash)"
