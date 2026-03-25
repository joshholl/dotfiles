#!/bin/sh
# Bootstrap script — installs chezmoi (if needed) and applies dotfiles.
# Usage: sh install.sh
#        sh install.sh --apply     (non-interactive apply)
#
# One-liner:
#   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <github-username>

set -e

CHEZMOI_BIN="$HOME/.local/bin/chezmoi"
REPO="https://github.com/joshholl/dotfiles"

# Install chezmoi if not already on PATH
if ! command -v chezmoi >/dev/null 2>&1; then
  if ! [ -x "$CHEZMOI_BIN" ]; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  fi
  export PATH="$HOME/.local/bin:$PATH"
fi

# Apply dotfiles
if [ "$1" = "--apply" ]; then
  chezmoi init --apply "$REPO"
else
  chezmoi init "$REPO"
  echo ""
  echo "Run 'chezmoi apply' to apply dotfiles."
  echo "Run 'chezmoi diff'  to preview changes."
fi
