# My Dotfiles

So, you found my dotfiles. Like most dotfiles repo's you're not likely to be able to use mine directly but I hope if you come across them and find something spiffy you use it. Also, feel free to throw up an issue if you have a suggestion. 

# Whats Here
Here is a list of software I have configurations for

- `1password` - secret manager
- `asdf` - to manage all of my compilers/interpreters and a few tools (like terraform)
- `git` - basic git config
- `homebrew` - installer for macOS systems
- `jq` - some definitions that i have found helpful
- `nala` - apt frontend for Debian systems that supports concurrent downloads
- `neovim` - preferred editor
- `starship` - my prompt
- `tmux` - not used much, soon to be deleted
- `paru` - installer for arch linux
- `vscode` - IDE of choice (has a run script to install extensions)
- `wezterm` - terminal emulator
- `zsh` - my preferred shell
    - `zinit-continuum` - plugin manager for zsh

# What Systems does this work on

- **Arch Linux** - Not as heavily tested, but used some
- **PopOS** - Ubuntu derivative thats my desktop os
- **Ubuntu (Jammy)** - Typical base for virtual machines
- **Debian (Stretch)** - OS for some HomeLab systems (TrueNAS Scale)
- **macOS (Ventura)** - My laptops
    - **x86_64** - My work 2019 MacBook Pro 16 
    - **m2** - My personal 2022 MacBook Air

## Coming soon potentially??

- `FreeBSD` - used for some systems in my homelab 
- `Windows/WSL` - I hope I never have to use Windows, but if such a time comes where I have to work on windows a significant amount I will add support

# Context

So some of my decisions here suck; some may be awesome. My dotfiles came to be after I got tired of manually creating my configurations every time I got a new machine (or nuked the OS). Anymore, I treat my OS as completely ephemeral because hacking around on them invariably messes something up at some point. As such, my dotfiles also install my packages for softwares I use. Finally, I am a Data Streaming Architect (I design data pipelines and distributed, event sourced systems) and ex software engineer. I am no longer an IC and coding is often only for PoC/Personal projects at this point