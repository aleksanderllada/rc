# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

CASE_SENSITIVE="true"
CLICOLOR=1

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
source ~/.aliases

# Zsh plugins
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "zdharma/fast-syntax-highlighting", as:plugin, defer:2
zplug load
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

rehash

# Set default editor to Vim
export EDITOR="vim"

# Bind Shift+Left and Shift+Right to move between words
bindkey "^[[1;2C" forward-word
bindkey "^[[1;2D" backward-word

# Bind Home and End to move to the beginning and end of the line
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Set fzf default command to exclude .git
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Edit command line in Vim on ^X^E
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

export SDKROOT=$(xcrun -sdk macosx --show-sdk-path)
export PATH=/opt/homebrew/opt/openssl@3/bin:$PATH
export PATH=/usr/local/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVS_HOME="$HOME/.nvs"
[ -s "$NVS_HOME/nvs.sh" ] && . "$NVS_HOME/nvs.sh"

# Wire up `direnv` to the `cd` command of the shell
eval "$(direnv hook zsh)"

# Increase the timeout for triggering the warning message
# on long running commands invoked by `direnv`
export DIRENV_WARN_TIMEOUT=60s
