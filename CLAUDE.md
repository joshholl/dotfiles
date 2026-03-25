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
  .chezmoidata/                # Static template data
  .chezmoiscripts/             # Run scripts (onchange hooks)
    darwin/                    # macOS-only scripts
    linux/                     # Linux-only scripts
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

### Secrets via 1Password

Templates pull secrets with `{{ onepasswordRead "op://vault/item/field" }}`. This requires `op` (1Password CLI) to be authenticated. Both personal and work machines run 1Password (with separate, unassociated accounts), so the `[onepassword]` integration is enabled for both machine types.

### onchange Scripts

Scripts in `.chezmoiscripts/` run automatically when their content changes (chezmoi hashes the file). The numbering prefix (10, 20, ...) controls execution order:
- `darwin/run_onchange_10_*.sh.tmpl` — Homebrew bundle install
- `darwin/run_onchange_20_*.sh.tmpl` — macOS system defaults
- `linux/run_onchange_10_*.sh.tmpl` — Linux package install (apt/pacman)

Scripts include the shared library via `{{- template "scripts-library" . }}`.

### Local Overrides

Machine-specific config not tracked in git goes in local override files (not managed by chezmoi):
- `~/.zshrc.local` — sourced at end of `.zshrc`
- `~/.ssh/config.local` — included at end of SSH config

## Key Design Decisions

- **Rebase-by-default**: git pull uses rebase (`pull.rebase = true`)
- **Delta pager**: all git output goes through `delta` for side-by-side diffs
- **mise over nvm/pyenv**: runtime version management via `mise` (configured in `.zshrc`)
- **Modern CLI aliases**: `ls`→`eza`, `cat`→`bat`, `find`→`fd` in `aliases.sh`
- **1Password SSH agent**: SSH signing and agent forwarding enabled on both personal and work machines (separate, unassociated accounts)
