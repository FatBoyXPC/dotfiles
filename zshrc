# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

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
autoload -Uz compinit
compinit

# Show hostname in the prompt if ssh
if [[ -n "$SSH_CONNECTION" ]]; then
    PROMPT="%m $PROMPT"
fi

function alf() {
    local foo=$(alias | fzf | sed "s/.*='\(.*\)'/\1/")
    eval $foo
}

function de {
    CMD="docker exec -it --detach-keys='ctrl-^,q' $1 env TERM=xterm bash"
    echo $CMD
    $CMD
}

function dsf {
    diff -u --color=always "$@" | diff-so-fancy | less "$LESS"
}

function cgl {
    ~/bin/git-commit-link.py $1 | clipit
}

function clcl {
    cgl `git rev-parse HEAD`
}

function filerange() {
    local file=$1
    local start=$2
    local end=$3
    local line_count=$(cat "$file" | wc -l)
    local file_output=$(cat "$file")

    if [ $line_count -ge $end ]; then
        file_output=$(echo $file_output | head -n $end)
    fi

    if [ $start -ge 1 ]; then
        diff_range=$(($end-$start+1))
        file_output=$(echo $file_output | tail -n $diff_range)
    fi

    echo $file_output
}

function filediff() {
    local file=$1
    local start_a=$2
    local end_a=$3
    local start_b=$4
    local end_b=$5

    dsf <(filerange $file $start_a $end_a) <(filerange $file $start_b $end_b)
}

function copyimage() {
    local imagetype=$(xdg-mime query filetype "$1")
    xclip -selection clipboard -t "$imagetype" -i < "$1"
}

function a3() {
    _a3cli_start_time=`date +%s`
    docker exec webhost php acli.php --ansi $*
    _a3cli_exit_status=$? # Store the exit status so we can return it later

    if [[ $1 = "make:"* && $ARTISAN_OPEN_ON_MAKE_EDITOR != "" ]]; then
        # Find and open files created by artisan
        _a3cli_path=`dirname acli.php`
        find \
            "$_a3cli_path/system/db/sql/migrations" \
            -type f \
            -newermt "-$((`date +%s` - $_a3cli_start_time + 1)) seconds" \
            -exec $OPEN_ON_MAKE_EDITOR {} \; 2>/dev/null
    fi

    return $_artisan_exit_status
}

compdef _a3_add_completion a3

function _a3_add_completion() {
    compadd `_a3_get_command_list`
}

function _a3_get_command_list() {
    docker exec webhost php acli.php --raw --no-ansi list | sed "s/[[:space:]].*//g"
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
