# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    PS1='\u@\h \w [env]\$ '
else
    PS1='\u@\h \w\$ '
fi
alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/gnu/store/x8vi885valbnsx9ddxb192ygjq4ws161-conda-4.10.3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/gnu/store/x8vi885valbnsx9ddxb192ygjq4ws161-conda-4.10.3/etc/profile.d/conda.sh" ]; then
        . "/gnu/store/x8vi885valbnsx9ddxb192ygjq4ws161-conda-4.10.3/etc/profile.d/conda.sh"
    else
        export PATH="/gnu/store/x8vi885valbnsx9ddxb192ygjq4ws161-conda-4.10.3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Created by `pipx` on 2021-11-08 21:31:47
export PATH="$PATH:/home/m/.local/bin"
