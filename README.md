# dotfiles

zsh, git, tmux, and Neovim config, managed with [chezmoi](https://www.chezmoi.io/).

This repo is deliberately just the dotfiles — no package installs, no
system provisioning. That lives in a separate repo,
[workstation-setup](https://github.com/dominhtim/workstation-setup), which
provisions a fresh machine and then applies this repo as its last step.
Nothing stops you from using this repo on its own, though — it doesn't
know or care that the other repo exists.

## Quick start

On a machine that already has chezmoi installed:

```bash
chezmoi init --apply dominhtim/dotfiles
```

You'll be asked for your git name/email once — chezmoi remembers the
answer in `~/.config/chezmoi/chezmoi.toml` and won't ask again on this
machine.

Don't have chezmoi yet? [Install it](https://www.chezmoi.io/install/),
then run the command above. Or use `workstation-setup`, which installs
chezmoi for you as part of setting up the rest of the machine.

## Layout

```
dotfiles/
├── .chezmoi.toml.tmpl      ← prompts for name/email on first `chezmoi init`
├── dot_zshrc.tmpl
├── dot_gitconfig.tmpl
├── dot_gitignore_global
├── dot_tmux.conf
└── dot_config/nvim/        ← lazy.nvim, LSP via Mason, Telescope, Treesitter
```

Each name encodes what it becomes: `dot_zshrc` → `~/.zshrc`,
`dot_config/nvim/init.lua` → `~/.config/nvim/init.lua`. A `.tmpl` suffix
means it's a template (Go template syntax, `{{ }}`), rendered using data
from `chezmoi.toml`.

To edit something once it's applied: `chezmoi edit ~/.zshrc` opens the
*source* file in this repo, not the copy sitting in your home directory.
After editing, `chezmoi apply` re-renders it out to `$HOME`. `chezmoi diff`
shows you what would change before you commit to it.

## Why chezmoi instead of a symlink farm (Stow, etc.)

Stow-style tools just symlink — no templating, so a repo like this can't
produce slightly different output on different machines without manually
maintained per-machine override files. chezmoi's source files are real
templates: `dot_gitconfig.tmpl` bakes your actual name/email in directly
(asked once, remembered per-machine) instead of needing a separate
`.gitconfig.local` you'd have to hand-recreate everywhere. `dot_zshrc.tmpl`
has a working example of this — the clipboard alias resolves to `xclip` on
Linux and `pbcopy`/`pbpaste` on macOS from the exact same source line:

```
{{- if eq .chezmoi.os "darwin" }}
alias pbc='pbcopy'
{{- else }}
alias pbc='xclip -selection clipboard'
{{- end }}
```

## Local overrides (never committed, never templated)

`~/.zshrc.local` is sourced at the end of `.zshrc` and stays completely
outside chezmoi/git — for one-off, don't-care-if-it's-tracked shell
tweaks. Anything that's a real, known-in-advance per-machine value
(identity, OS-specific paths) should go through chezmoi templating instead,
the way `.gitconfig` and the clipboard aliases do.

## Vim → Neovim

The old `.vimrc` ran vim-plug + YouCompleteMe, which needed a C++ compile
step and broke across version bumps more than it should have. This config
uses the built-in LSP client + `nvim-cmp`, with **Mason** installing
language servers as precompiled binaries — `:Mason` and pick one, no
compiling.

| Old (vim-plug)  | New (lazy.nvim)                                 |
| --------------- | ------------------------------------------------ |
| vim-surround    | nvim-surround                                     |
| vim-fugitive    | vim-fugitive (unchanged)                          |
| ale             | native LSP diagnostics (via Mason)                |
| vim-airline     | lualine.nvim                                      |
| gruvbox         | gruvbox.nvim (maintained Neovim port)             |
| YouCompleteMe   | nvim-cmp + LSP completion, no compiling           |
| —               | Telescope (fuzzy file/text search) — new          |
| —               | Treesitter (real syntax parsing) — new            |
| —               | which-key (shows keybindings as you type) — new   |

Plugins install automatically the first time you open `nvim` after
`chezmoi apply` — wait for lazy.nvim to finish, then restart.

## Fonts (read this if the prompt looks like garbled boxes)

Powerlevel10k's icons need a [Nerd Font](https://www.nerdfonts.com/)
installed on whatever you're **looking at the terminal with** — if you're
connecting to a VM from Windows Terminal, install MesloLGS NF on Windows
and set it in the Windows Terminal profile. Installing a font inside the
VM does nothing for how text renders on your screen.

## Uninstall

```bash
chezmoi purge
```

Removes chezmoi's config and its clone of this repo. Your actual dotfiles
(`~/.zshrc`, `~/.gitconfig`, etc.) are real files at that point, not
symlinks — delete them by hand if you want them gone too.
