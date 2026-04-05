#!/bin/bash
# Bootstrap dotfiles on a new machine.
#
# Usage (repo must be public):
#   curl -fsSL https://raw.githubusercontent.com/joshholl/dotfiles/main/install.sh | bash
#
# Or clone first, then run directly:
#   bash ~/Source/dotfiles/install.sh

set -euo pipefail

REPO="https://github.com/joshholl/dotfiles"
AGE_KEY_PATH="$HOME/.config/sops/age/keys.txt"

# ── Helpers ───────────────────────────────────────────────────────────────────

info()  { printf '\033[0;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[0;33mWARN:\033[0m %s\n' "$*"; }
abort() { printf '\033[0;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# Read from the terminal even when stdin is a pipe (curl | bash)
tty_read() {
  local prompt="$1" var_name="$2"
  local val
  val=$(bash -c 'read -r -p "$1" val </dev/tty && echo "$val"' _ "$prompt")
  eval "$var_name=\$val"
}

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
  export PATH="$HOME/.local/bin:$PATH"
else
  export PATH="$HOME/.local/bin:$PATH"
  info "chezmoi already installed ($(chezmoi --version))"
fi

# ── age key (required for SOPS secrets) ───────────────────────────────────────

if [[ ! -f "$AGE_KEY_PATH" ]]; then
  echo ""
  warn "No age key found at $AGE_KEY_PATH"
  warn "This is required to decrypt secrets. You have two options:"
  echo ""
  echo "  1) Paste your age private key now (press Ctrl+D when done)"
  echo "  2) Skip — chezmoi will apply but secrets will fail to decrypt"
  echo ""
  tty_read "Paste age key now? [y/N] " answer

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    mkdir -p "$(dirname "$AGE_KEY_PATH")"
    read -r age_key </dev/tty
    echo "$age_key" > "$AGE_KEY_PATH"
    chmod 600 "$AGE_KEY_PATH"
    info "Age key saved to $AGE_KEY_PATH"
  else
    warn "Skipping age key — secrets-dependent templates may fail during apply."
  fi
else
  info "Age key found at $AGE_KEY_PATH"
fi

# ── chezmoi init + apply ───────────────────────────────────────────────────────

echo ""
info "Running: chezmoi init --apply $REPO"
echo ""

chezmoi init --apply "$REPO" </dev/tty

echo ""
info "Done! Restart your shell: exec zsh"
