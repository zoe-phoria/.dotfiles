#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
export BASH_SLIENCE_DEPRECATION_WARNING=1

if [[ -f /opt/local/bin/port ]]; then
    # MacPorts Installer addition on 2025-05-04_at_11:45:14: adding an appropriate PATH variable for use with MacPorts.
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi

