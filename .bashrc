#              /\       
#    _        /  \         _              
#   | |__    /\   \    ___| |__  _ __ ___ 
#   | '_ \  /      \  / __| '_ \| '__/ __/
#  _| |_) |/   ,,   \ \__ \ | | | | | (__ 
# (_)_.__//   |  |  -\\___/_| |_|_|  \___\
#        /_-''    ''-_\
# .bashrc by zoe 

# enable vi mode
set -o vi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTFILE=$HOME/.bash_history
HISTCONTROL=ignorespace:ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# history length
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%y-%m-%d %H:%M "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# use "**" as wildcard for paths
if [[ $OSTYPE == linux-gnu ]]; then
    shopt -s globstar
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in prompt below) to content of /etc/arch_chroot of current chroot
if [ -z "${arch_chroot:-}" ] && [ -r /etc/arch_chroot ]; then
    arch_chroot=$(cat /etc/arch_chroot)
fi

# test for color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # if tput setaf works it can probably do color
    color_prompt=yes
else
    color_prompt=no
fi

# custom bash prompt
if [ "$color_prompt" = yes ]; then
    PS1="\[\e[48;5;236m\] \[\033[01;35m\]${arch_chroot:+($arch_chroot) }\[\033[01;32m\]\u@\h\[\033[00m\]\[\e[48;5;236m\] \[\e[0m\]:\[\033[01;36m\]\w\[\033[00m\]\$ "
else
    PS1=" ${arch_chroot:+($arch_chroot)}\u@\h:\w\$ "
fi
unset color_prompt

# enable color and hyperlink support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --hyperlink=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# remove yay make dependencies by default
if [ -x /usr/bin/yay ]; then
    alias yay='yay --removemake'
fi

# autocomplete
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# homebrew autocomplete (only on macos)
if [[ $OSTYPE == "darwin"* ]]; then
    if type brew &>/dev/null; then
        HOMEBREW_PREFIX="$(brew --prefix)"
        if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
            source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
        else
            for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
            do
            [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
            done
        fi
    fi
fi

# set default editor
export VISUAL=vim
export EDITOR=$VISUAL

# add ~/bin to PATH
export PATH=$PATH:$HOME/bin
# add rustup binaries to $PATH on macos
if [[ $OSTYPE == "darwin"* && -d /usr/local/Cellar/rustup/1.27.1_1/bin/ ]]; then
    export PATH=$PATH:/usr/local/Cellar/rustup/1.27.1_1/bin
fi

# include rust binaries on linux
if [[ $OSTYPE == "linux-gnu" && -f $HOME/.cargo/env ]]; then
    . "$HOME/.cargo/env"
fi

# set ssh auth socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# aliases
alias :q='exit'
alias :qa='exit'
if [[ $OSTYPE == "darwin"* && -f $HOME/bin/brewint ]]; then
    alias yoink='/bin/bash $HOME/bin/brewint -u'
elif [[ -n $(cat /etc/os-release | grep "Arch Linux") && -f $HOME/bin/pacint ]]; then
    alias yoink='/bin/bash $HOME/bin/pacint -u'
elif [[ -n $(cat /etc/os-release | grep "debian") ]]; then
    alias yoink='sudo apt update && sudo apt upgrade && sudo apt autoremove'
fi
alias mnt='sudo mount -a'
alias unouploadasp='arduino-cli compile -v -b arduino:avr:uno -u -P usbasp '
alias nanouploadasp='arduino-cli compile -v -b arduino:avr:nano -u -P usbasp '
alias unoupload='arduino-cli compile -v -b arduino:avr:uno -u'
alias nanoupload='arduino-cli compile -v -b arduino:avr:nano -u'
alias pip='python -m pip'
alias icat='kitty +kitten icat'
alias doccat='odt2txt'
alias hst="history | fzf --tac | cut -c 8- | sed -Ez '$ s/\n+$//' | tr -d '\n' | xclip -sel c"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"' # add && alert to long commands
alias uncomment-all-mirrors="sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.pacnew"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
if [ -f /usr/share/doc/ranger/examples/shell_automatic_cd.sh ]; then
    source /usr/share/doc/ranger/examples/shell_automatic_cd.sh
    alias ranger='ranger_cd'
fi
if [ -f $HOME/.ssh_alias ]; then
    source $HOME/.ssh_alias
fi

# auto startx on tty1
if [[ -z $(pgrep gdm) && -z "${DISPLAY}" && "${XDG_VTNR}" -eq 1 ]]; then
  exec startx -- -keeptty > /tmp/.xorg.log 2>&1
fi

# auto start GNOME keyring with xinit
if [[ -n $(pgrep xinit) ]]; then
    if [ -n "$DESKTOP_SESSION" ];then
        eval $(gnome-keyring-daemon --start)
        export SSH_AUTH_SOCK
    fi
fi

# print welcome message when last sync (syncDocs.sh/syncPass.sh) was unsuccessful
if [[ -f $HOME/.sync.err ]]; then
    printf "last sync unsuccessful (see $HOME/.sync.err)\n"
fi

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
