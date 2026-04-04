# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **chezmoi-managed dotfiles repository**. The `home/` directory is the chezmoi source root (set via `.chezmoiroot`) and maps to `~/` when applied. Configuration is template-driven, supporting multiple machine types and platforms.

## Common Commands

```bash
# Apply all dotfiles to the home directory
chezmoi apply

# Preview what would change before applying
chezmoi diff

# Apply a single file
chezmoi apply ~/.zshrc

# Re-run a specific onchange script (by modifying its content hash)
chezmoi apply --force

# Add a new dotfile to be managed
chezmoi add ~/.config/foo/bar

# Edit a managed file (opens in $EDITOR, applies on save)
chezmoi edit ~/.zshrc

# Re-run the initial template configuration prompts
chezmoi init --data=false
```

## File Naming Conventions

chezmoi uses filename prefixes/suffixes to determine behavior:
- `dot_*` → deployed as `.*` (e.g., `dot_zshrc` → `~/.zshrc`)
- `private_*` → deployed with mode 600 (e.g., `private_dot_ssh/`)
- `*.tmpl` → processed as Go templates before deployment
- `run_onchange_NN_*.sh` → run when file content changes (ordered by NN prefix)
- `.chezmoiignore.tmpl` → conditionally excludes files from deployment

## Architecture

### Directory Structure
```
home/                          # chezmoi source root
  .chezmoidata/                # Static template data + SOPS-encrypted secrets
  .chezmoiscripts/             # Run scripts
    run_once_00-install-mise.sh              # bootstrap mise (cross-platform)
    run_onchange_10-install-mise-tools.sh.tmpl  # mise install (cross-platform)
    darwin/                    # macOS-only scripts
      run_once_20-install-gui-apps.sh.tmpl  # GUI app installs (personal)
      run_once_30-install-fonts.sh.tmpl     # Nerd Font download
    linux/                     # Linux-only scripts
    personal/                  # Personal-machine-only scripts (run_once)
  .chezmoitemplates/           # Reusable template partials
    scripts-library            # Logging + helper functions for scripts
  dot_config/
    git/                       # Git config + global ignore
    shell/                     # aliases.sh, exports.sh.tmpl
    starship/                  # Starship prompt config
  dot_zshrc.tmpl               # Main zsh config
  private_dot_ssh/             # SSH config (mode 600)
```

### Templating & Machine Types

`.chezmoi.toml.tmpl` prompts once at init time and stores values in `~/.config/chezmoi/chezmoi.toml`. Available template variables:
- `{{ .machineType }}` — `personal`, `work`, or `headless`
- `{{ .osID }}` — `linux-ubuntu`, `linux-arch`, `darwin`, etc.
- `{{ .name }}` / `{{ .email }}` — Git identity
- `{{ .personal }}` — boolean shorthand for `machineType == "personal"`

Use `{{ if eq .machineType "personal" }}...{{ end }}` for conditional config blocks.

### Secrets

**Personal machines — SOPS + age:**

Secrets are stored in `home/.chezmoidata/secrets.sops.yaml` (committed, age-encrypted). The age key is managed out-of-band and must exist at `~/.config/sops/age/keys.txt` before running `chezmoi apply`.

`.sops.yaml` at the repo root configures the age recipient — update it with your public key before encrypting new files:
```bash
# Get your age public key
age-keygen -y ~/.config/sops/age/keys.txt

# Encrypt a secrets file
sops --encrypt home/.chezmoidata/secrets.yaml > home/.chezmoidata/secrets.sops.yaml
rm home/.chezmoidata/secrets.yaml
```

Use secrets in templates via:
```
{{- $s := output "sops" "--decrypt" (joinPath .chezmoi.sourceDir "home/.chezmoidata/secrets.sops.yaml") | fromYaml -}}
{{ $s.some_token }}
```

See `home/.chezmoidata/secrets.sops.yaml.example` for the expected structure.

**Work machines — 1Password:**

The `[onepassword]` integration is enabled for work machines only. Templates can use `{{ onepasswordRead "op://vault/item/field" }}` after `op signin`.

### SSH Keys

**Personal machines — `~/.ssh/id_personal`:**

A `run_once` script (`personal/run_once_10_load-yubikey-ssh-key.sh.tmpl`) populates `~/.ssh/id_personal` on first `chezmoi apply`. SSH config and git signing always reference this stable name regardless of what backs it.

- **If YubiKey is present**: loads the resident key from the hardware key into `id_personal`
- **If no YubiKey**: generates a temporary `ed25519` software key and prints transition instructions

**To generate the resident key on a new YubiKey** (once per key, requires FIDO2 PIN set via YubiKey Manager first):
```bash
# Touch-only — recommended. Each use requires a physical tap, no PIN prompt.
ssh-keygen -t ed25519-sk -O resident -C "yubikey-personal" -f ~/.ssh/id_personal

# PIN + touch on every use — stricter but interrupts terminal workflows.
# ssh-keygen -t ed25519-sk -O resident -O verify-required -C "yubikey-personal" -f ~/.ssh/id_personal
```

**To transition from software key to YubiKey** when hardware arrives:
```bash
cd ~/.ssh && ssh-keygen -K
mv id_ed25519_sk_rk id_personal && mv id_ed25519_sk_rk.pub id_personal.pub
chmod 600 id_personal && chmod 644 id_personal.pub
# Re-register id_personal.pub with GitHub/GitLab, remove the old key
```

Git commit signing uses native `ssh-keygen` with the key — no `op-ssh-sign` needed. macOS 12+ has FIDO2 support built into its system OpenSSH; no extra libraries required.

**Work machines — 1Password SSH agent:**

SSH agent socket and `op-ssh-sign` for git commit signing are configured automatically.

### onchange Scripts

Scripts in `.chezmoiscripts/` run automatically when their content changes (chezmoi hashes the file). The numbering prefix (10, 20, ...) controls execution order:
- `darwin/run_onchange_10_*.sh.tmpl` — Homebrew bundle install
- `darwin/run_onchange_20_*.sh.tmpl` — macOS system defaults
- `linux/run_onchange_10_*.sh.tmpl` — Linux package install (apt/pacman)
- `personal/run_once_10_*.sh.tmpl` — Personal-only one-time setup (YubiKey key load, etc.)

Scripts include the shared library via `{{- template "scripts-library" . }}`.

### Local Overrides

Machine-specific config not tracked in git goes in local override files (not managed by chezmoi):
- `~/.zshrc.local` — sourced at end of `.zshrc`
- `~/.ssh/config.local` — included at end of SSH config

## Key Design Decisions

- **Rebase-by-default**: git pull uses rebase (`pull.rebase = true`)
- **Delta pager**: all git output goes through `delta` for side-by-side diffs
- **No Homebrew**: CLI tools managed by `mise` (ubi/aqua backends pull GitHub release binaries); GUI apps installed via direct DMG/PKG download in a `run_once` script and left to self-update
- **mise over nvm/pyenv**: runtime version management via `mise` (configured in `.zshrc`); also manages all CLI tools via `~/.config/mise/config.toml`
- **Modern CLI aliases**: `ls`→`eza`, `cat`→`bat`, `find`→`fd` in `aliases.sh`
- **Personal SSH**: YubiKey resident key (`ed25519-sk`) — hardware-backed, same key across machines, loaded via `run_once` script
- **Work SSH**: 1Password SSH agent + `op-ssh-sign` for commit signing
- **SOPS secrets**: Personal secrets encrypted with `age` in `home/.chezmoidata/secrets.sops.yaml`; age key managed out-of-band at `~/.config/sops/age/keys.txt`
