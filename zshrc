# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel10k/powerlevel10k"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
##################################

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=1

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git composer docker docker-compose chucknorris z artisan)

source $ZSH/oh-my-zsh.sh

# User configuration

# Create PATH env variable
source ~/.pathrc
# export MANPATH="/usr/local/man:$MANPATH"
export XDEBUG_CONFIG="idekey=sublime.xdebug"
export TERM="xterm-256color"
export EDITOR="vim"
export VISUAL=$EDITOR
export SUDO_ASKPASS=/usr/lib/ssh/x11-ssh-askpass
export OPEN_ON_MAKE_EDITOR=dvo
export ARTISAN_OPEN_ON_MAKE_EDITOR=$OPEN_ON_MAKE_EDITOR
export FZF_DEFAULT_COMMAND='ag -U --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export LESS=-RF

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# I like auto Updates...
DISABLE_UPDATE_PROMPT=true

eval `dircolors ~/.dircolors`

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*:*:make:*' tag-order 'targets'
autoload -Uz compinit
compinit

# Show hostname in the prompt if ssh
if [[ -n "$SSH_CONNECTION" ]]; then
    PROMPT="%m $PROMPT"
fi

function de {
    CMD="docker exec -it --detach-keys='ctrl-^,q' $1 env TERM=xterm bash"
    echo $CMD
    $CMD
}

bindkey '\ev' edit-command-line

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

###
### Bash-like navigation - stolen from https://github.com/jfly/dotfiles/blob/d0e0fa39442783b299be741aa2e171b97fef5357/zshrc
### Copied from: https://stackoverflow.com/a/10860628/1739415
### Also see https://stackoverflow.com/a/3483679/1739415
###

# Bind ctrl-u to cut to beginning of line.
bindkey "^U" backward-kill-line

# Change behavior of alt-b and alt-f to behave more like bash with regards to
# trailing whitespace.
autoload -Uz forward-word-match
zle -N forward-word forward-word-match
zstyle ':zle:*' skip-whitespace-first true
zstyle ':zle:*' word-chars ''

# Bind alt-backspace to delete one not so aggressive word backwards.
bindkey '^[^?' backward-kill-word

### Bind ctrl-w to delete one aggressive word backwards.
backward-kill-dir() {
    local WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey "^W" backward-kill-dir

#####################


####
### Set up ctrl-shift-n for VTE
###
[[ -f /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
##################################

# From https://wiki.archlinux.org/index.php/SSH_keys#ssh-agent
if ! pgrep -u $USER ssh-agent > /dev/null; then
  ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
  eval $(<~/.ssh-agent-thing)
fi

[[ -z $DISPLAY && -z $TMUX && $XDG_VTNR -eq 1 ]] && exec startx
