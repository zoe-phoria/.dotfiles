#              /\       
#    _        /  \         _              
#   | |__    /\   \    ___| |__  _ __ ___ 
#   | '_ \  /      \  / __| '_ \| '__/ __/
#  _| |_) |/   ,,   \ \__ \ | | | | | (__ 
# (_)_.__//   |  |  -\\___/_| |_|_|  \___\
#        /_-''    ''-_\
# .bashrc for root by zoe 


# enable vi mode
set -o vi

# set default editor
export VISUAL=vim
export EDITOR=$VISUAL

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# test for color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # if tput setaf works it can probably do color
    color_prompt=yes
    else
    color_prompt=no
fi

# custom bash prompt
if [ "$color_prompt" = yes ]; then
    PS1="\[\e[48;5;236m\] \[\033[01;35m\]${arch_chroot:+($arch_chroot) }\[\033[01;31m\]\u@\h\[\033[00m\]\[\e[48;5;236m\] \[\e[0m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
else
    PS1=' ${arch_chroot:+($arch_chroot)}\u@\h:\w\$ '
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# autocomplete
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# aliases
alias :q='exit'
