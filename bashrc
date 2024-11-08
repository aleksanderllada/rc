source ~/.bash_aliases
export EDITOR=vim
force_color_prompt=yes
export PS1="\[\e[01;33m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;36m\]\h\[\e[0m\]\[\e[00;37m\] \t \[\e[0m\]\[\e[01;35m\]\w\[\e[0m\]\[\e[01;37m\] \[\e[0m\]$ "

# Load mtime at bash start-up
export BASH_ALIASES_MTIME=$(stat -f "%m" ~/.bash_aliases)
export PATH=$PATH:/Users/aleksander/go/bin

# Required for rbenv to work properly
export PATH="$HOME/.rbenv/shims:$PATH"

export PROMPT_COMMAND="check_and_reload_bash_aliases"
check_and_reload_bash_aliases () {
  if [ "$(stat -f "%m" ~/.bash_aliases)" != "$BASH_ALIASES_MTIME" ]; then
    export BASH_ALIASES_MTIME="$(stat -f "%m" ~/.bash_aliases)"
    echo "bash_aliases changed. re-sourcing..." >&2
    . ~/.bash_aliases
  fi
}
