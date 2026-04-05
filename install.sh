#!/bin/bash
# Bootstrap dotfiles on a new machine.
#
# Usage (repo must be public):
#   curl -fsSL https://raw.githubusercontent.com/joshholl/dotfiles/main/install.sh | bash
#
# Or clone first, then run directly:
#   bash ~/Source/dotfiles/install.sh

set -euo pipefail

# When piped from curl, stdin is the pipe — reopen it from the terminal so all
# subsequent `read` calls and interactive prompts work normally.
if [[ ! -t 0 ]]; then
  exec </dev/tty
fi

REPO="https://github.com/joshholl/dotfiles"
AGE_KEY_PATH="$HOME/.config/sops/age/keys.txt"

info()  { printf '\033[0;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[0;33mWARN:\033[0m %s\n' "$*"; }

# ── macOS: Xcode Command Line Tools ───────────────────────────────────────────

if [[ "$(uname -s)" == "Darwin" ]]; then
  if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo ""
    warn "Xcode CLT installation triggered. Wait for it to finish, then re-run this script."
    exit 0
  fi
fi

# ── chezmoi ───────────────────────────────────────────────────────────────────

if ! command -v chezmoi &>/dev/null; then
  info "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi
export PATH="$HOME/.local/bin:$PATH"
info "chezmoi $(chezmoi --version | awk '{print $3}')"

# ── age key (required for SOPS secrets) ───────────────────────────────────────

if [[ ! -f "$AGE_KEY_PATH" ]]; then
  echo ""
  warn "No age key found at $AGE_KEY_PATH"
  warn "This is required to decrypt secrets."
  echo ""
  read -r -p "Paste your age private key now (AGE-SECRET-KEY-1...): " age_key
  echo ""

  if [[ -n "$age_key" ]]; then
    mkdir -p "$(dirname "$AGE_KEY_PATH")"
    echo "$age_key" > "$AGE_KEY_PATH"
    chmod 600 "$AGE_KEY_PATH"
    info "Age key saved."
  else
    warn "No key entered — secrets-dependent templates will fail during apply."
  fi
else
  info "Age key found."
fi

# ── chezmoi init + apply ───────────────────────────────────────────────────────

echo ""
info "Running chezmoi init --apply ..."
echo ""

chezmoi init --apply "$REPO"

echo ""
info "Done! Restart your shell: exec zsh"
