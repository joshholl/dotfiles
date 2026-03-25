#!/bin/sh
# Cross-platform shell aliases — sourced by both .zshrc and .bashrc

# ── Modern CLI replacements ───────────────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -la --group-directories-first --git'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  alias ll='ls -lah'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --plain'
fi

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# ── Git shortcuts ─────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate --all'

# ── Misc ──────────────────────────────────────────────────────────────────────
alias reload='exec $SHELL -l'
alias path='echo $PATH | tr ":" "\n"'
alias ports='ss -tulnp 2>/dev/null || netstat -tulnp'
alias myip='curl -s https://api.ipify.org && echo'
