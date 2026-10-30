# .bashrc (managed by dev_env, migrated 2026-10)

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# ===== 彩色提示符：绿 user@host + 蓝 cwd =====
_host=${HOSTNAME##*-}; _host=${_host%%.*}
PS1='[\[\e[1;32m\]\u@${_host}\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]]\$ '

# ===== 常用 alias =====
alias ls='ls --color=auto'
alias ll='ls -alF'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias tm='tmux attach || tmux new'
