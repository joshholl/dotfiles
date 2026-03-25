# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Secrets and SSH keys are stored in [1Password](https://1password.com/).

## Quick start

```sh
# One-liner — installs chezmoi and applies dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Joshholl

# Or clone and apply manually
git clone https://github.com/Joshholl/dotfiles.git ~/.local/share/chezmoi
chezmoi apply
```

## Structure

```
dotfiles/
├── .chezmoiroot          # shifts chezmoi source root → home/
├── .chezmoiversion       # minimum required chezmoi version
├── install.sh            # bootstrap script
└── home/                 # chezmoi source (maps to ~/)
    ├── .chezmoi.toml.tmpl          # machine-specific config (prompted once)
    ├── .chezmoiignore.tmpl         # OS-conditional ignores
    ├── .chezmoitemplates/
    │   └── scripts-library         # shared bash helpers for scripts
    ├── .chezmoiscripts/
    │   ├── darwin/                 # macOS-only scripts
    │   │   ├── run_onchange_10-install-brew-packages.sh.tmpl
    │   │   └── run_onchange_20-configure-macos-defaults.sh
    │   └── linux/                  # Linux-only scripts
    │       └── run_onchange_10-install-apt-packages.sh.tmpl
    ├── dot_config/
    │   ├── git/config.tmpl         # git config (name/email from chezmoi data)
    │   ├── git/ignore              # global .gitignore
    │   ├── shell/
    │   │   ├── aliases.sh          # cross-platform aliases
    │   │   └── exports.sh.tmpl     # env vars & PATH (OS-aware)
    │   └── starship/starship.toml  # prompt config
    ├── dot_zshrc.tmpl              # zsh config
    └── private_dot_ssh/
        └── config.tmpl             # SSH config (mode 600)
```

## Machine types

On first run, chezmoi prompts whether the machine is **personal** or **work**. These answers are stored and drive:

| Flag | Effect |
|---|---|
| `personal` | 1Password SSH agent socket, SSH commit signing, personal configs |
| `work` | Work-specific configs (kept out of this public repo) |
| `headless` | Auto-detected from `SSH_CLIENT`, `CI`, etc. |

## Secrets & 1Password

Secrets are **never committed**. Templates reference 1Password directly:

```toml
# In any .tmpl file:
{{ onepasswordRead "op://Personal/Item Name/field" }}
```

The 1Password CLI (`op`) must be installed and signed in. The SSH agent socket is configured automatically on personal machines via `~/.config/shell/exports.sh`.

## Local overrides

Machine-specific config that shouldn't be in version control goes in:

- `~/.zshrc.local` — shell customisations
- `~/.ssh/config.local` — additional SSH hosts

These files are sourced automatically but never tracked.

## Common commands

```sh
chezmoi diff          # Preview changes before applying
chezmoi apply         # Apply all changes
chezmoi edit ~/.zshrc # Edit a tracked file and apply
chezmoi update        # Pull latest and apply
chezmoi cd            # cd into source directory
```

## Adding a new dotfile

```sh
chezmoi add ~/.config/some-tool/config
chezmoi edit ~/.config/some-tool/config
chezmoi apply
```
