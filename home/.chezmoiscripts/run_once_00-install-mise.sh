#!/bin/bash
# Installs mise if not already present.
# run_once_ — fires exactly once per machine after a fresh chezmoi init.
set -euo pipefail

if command -v mise >/dev/null 2>&1; then
  echo "mise already installed ($(mise --version)) — skipping"
  exit 0
fi

echo "==> Installing mise..."
curl -fsSL https://mise.run | sh

# Ensure the shims directory is on PATH for the rest of this chezmoi run
export PATH="$HOME/.local/bin:$PATH"
echo "    mise installed: $(mise --version)"
