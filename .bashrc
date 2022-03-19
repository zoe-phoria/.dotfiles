###############################################
# .bashrc for Arch Linux by Zoe Luisa Mueller #
###############################################

# enable vi mode
set -o vi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
        *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTFILE=/home/zoe/.bash_history
HISTCONTROL=ignorespace:ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in prompt below) to content of /etc/arch_chroot of current chroot
if [ -z "${arch_chroot:-}" ] && [ -r /etc/arch_chroot ]; then
    arch_chroot=$(cat /etc/arch_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# custom bash prompt
if [ "$color_prompt" = yes ]; then
    PS1='\[\e[48;5;236m\] ${arch_chroot:+($arch_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]\[\e[48;5;236m\] \[\e[0m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1=' ${arch_chroot:+($arch_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${arch_chroot:+($arch_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color and hyperlink support of ls dir and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --hyperlink=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# autocomplete pacman querys
if [[ -f /etc/bash_completion ]]; then
    /etc/bash_completion
fi

# set default editor
export VISUAL=vim
export EDITOR=$VISUAL

# add ~/bin to PATH
export PATH=$PATH:$HOME/bin

# some shortcuts for ip adresses
export athena=192.168.0.3
export nas=$athena
export utopia=192.168.0.2
export pi=$utopia
export athanasia=192.168.0.1
export router=$athanasia

# include ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias update='/bin/bash /home/zoe/bin/updateall.sh'
alias orp='pacman -Qtdq'
alias mnt='sudo mount -a'
alias utopia='ssh ubuntu@192.168.0.2 -p 5022'
alias athena='ssh athena@192.168.0.3 -p 5022'
alias :q='exit'
alias :qa='exit'
alias glogout='gnome-session-quit'
alias unouploadasp='arduino-cli compile -v -b arduino:avr:uno -u -P usbasp '
alias nanouploadasp='arduino-cli compile -v -b arduino:avr:nano -u -P usbasp '
alias unoupload='arduino-cli compile -v -b arduino:avr:uno -u'
alias nanoupload='arduino-cli compile -v -b arduino:avr:nano -u'
alias icat='kitty +kitten icat'
alias ccd='cd $(find -type d,l | fzf -i)'
alias youtube='ytfzf'
alias yt='ytfzf'
alias y='ytfzf'
alias tty-clock='tty-clock -cB'
alias doccat='odt2txt'
alias hst="history | fzf --tac | cut -c 8- | sed -Ez '$ s/\n+$//' | tr -d '\n' | xclip -sel c"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
alias bin.github='/usr/bin/git --git-dir=$HOME/bin/bin.git --work-tree=$HOME/bin'
rofi-launcher()
{
    rofi -modi drun -show drun -run-shell-command \
    'kitty -e bash -ic "{cmd} && read"' & disown
}


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION