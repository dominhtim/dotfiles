# CLAUDE.md

Context for working on this repo. Everything here used to be comment blocks
inside the config files or sections of the README; it was moved out because
it is rationale and history, not documentation of what the config does.

## House rules

- **Comments in config are at most 2 lines.** They say why, not what. Anything
  needing a paragraph belongs in this file, with a `see CLAUDE.md` pointer in
  the config at most.
- **Don't use comments as a work log.** No "this used to be X", no "checked
  against both distros on <date>", no "replaces <old plugin>". `git log` and
  this file already hold that.
- **README.md is a README.** What this is, how to use it, how to change it.
  Not a migration diary, not a list of what was swapped for what.
- **No second person, no editorializing.** Comments don't say "your old
  setup", "you're navigating", "this alone is worth it", or "the actual payoff".
- `CLAUDE.md` must stay listed in `.chezmoiignore`, alongside `README.md` —
  otherwise chezmoi applies it into `$HOME`.

## chezmoi mechanics worth knowing

Source filenames encode their destination: `dot_zshrc` → `~/.zshrc`,
`dot_config/nvim/init.lua` → `~/.config/nvim/init.lua`. A `.tmpl` suffix means
Go template syntax rendered from the data in `~/.config/chezmoi/chezmoi.toml`.

`chezmoi edit ~/.zshrc` opens the **source** file here, not the copy in
`$HOME`. `chezmoi apply` renders it back out; `chezmoi diff` previews.

`.chezmoi.toml.tmpl` prompts once for name/email at `chezmoi init` and stores
the answers per-machine, which is what `dot_gitconfig.tmpl` interpolates.

## Why chezmoi rather than a symlink farm

Stow-style tools only symlink, so a single repo can't produce different output
on different machines without hand-maintained per-machine override files.
chezmoi's sources are real templates: `dot_gitconfig.tmpl` bakes in the actual
name/email (asked once, remembered per machine) instead of needing a separate
`.gitconfig.local` recreated everywhere. The clipboard aliases in
`dot_zshrc.tmpl` are the same idea — one source line resolving to `pbcopy` on
macOS and `xclip` on Linux.

`~/.zshrc.local` is sourced last and stays outside chezmoi and git entirely,
for one-off tweaks. Anything that's a real, known-in-advance per-machine value
should go through templating instead.

## Why the fzf sources use `/usr/share/doc/fzf/examples`

Debian 13 and Ubuntu both ship the key-bindings and completion scripts there;
this was checked against both distros' fzf packages. The `/usr/share/fzf` path
this file used to also try exists on neither.

`completion.zsh` has to be listed explicitly — neither distro's package sources
it, so `**` completion is otherwise silently off. It needs `compinit` to have
run already, which oh-my-zsh does further up the file.

## Why the statusline avoids Nerd Font glyphs

lualine's defaults need a Nerd Font **in the terminal you are looking at**.
Fonts resolve on the machine you're sitting at, so SSH'ing into a box renders
its nvim in the local terminal's font — installing fonts on the server changes
nothing. Without one you get replacement boxes.

Two separate settings are needed:

- `icons_enabled = false` covers the components that carry glyphs: `fileformat`
  (U+E712 for unix) falls back to the literal `unix`, and `filetype` stops
  asking nvim-web-devicons for an icon.
- It does **not** reach the separators, which are drawn from
  `component_separators` / `section_separators` and default to powerline glyphs
  (U+E0B0–E0B3). Blanking the section separators and using a plain bar is
  lualine's own no-Nerd-Font recipe; without it the setting above only
  half-works.

Powerlevel10k's prompt icons have the same requirement and no equivalent
escape hatch — install MesloLGS NF on whatever machine renders the terminal.

## Why nvim-treesitter is pinned to `master`

nvim-treesitter's default branch is now `main`, a complete and incompatible
rewrite that removed `nvim-treesitter.configs` — and with it `ensure_installed`,
`highlight` and `indent`. `master` is frozen, but the maintainers deliberately
kept it available for backward compatibility rather than deleting it.

## Why the LSP setup looks the way it does

`nvim-lspconfig` is still a dependency even though `require('lspconfig')` is
never called: it contributes each server's default config to the runtimepath,
which `vim.lsp.enable()` picks up. `vim.lsp.config()` / `vim.lsp.enable()`
replaced the old `require('lspconfig').<server>.setup{}` API, which is
deprecated.

Both landed in Neovim 0.11, and mason-lspconfig v2 calls `vim.lsp.enable()`
itself — so this config is **0.11-only**. On anything older the whole LSP layer
dies at startup with `attempt to call field 'config' (a nil value)`.
`workstation-setup` enforces that floor when provisioning a machine.

`lazy.nvim` runs with `rocks.enabled = false`: nothing here needs
luarocks-built native libraries, and leaving it on produces a cosmetic
`checkhealth` warning to ignore forever.

## History: the Vim setup this replaced

The old `.vimrc` ran vim-plug with YouCompleteMe, which needed a C++ compile
step and broke across version bumps. Mason installs language servers as
precompiled binaries instead.

| Old (vim-plug) | New (lazy.nvim)                    |
| -------------- | ---------------------------------- |
| vim-surround   | nvim-surround                      |
| vim-fugitive   | vim-fugitive (unchanged)           |
| ale            | native LSP diagnostics             |
| vim-airline    | lualine.nvim                       |
| gruvbox        | gruvbox.nvim                       |
| YouCompleteMe  | nvim-cmp + LSP, no compiling       |
| —              | Telescope, Treesitter, which-key   |

## Related

[workstation-setup](https://github.com/dominhtim/workstation-setup) provisions
a machine and applies this repo as its last step. This repo doesn't know that
one exists and works fine standalone. Keep it that way.
