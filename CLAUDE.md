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
`dot_zshrc.tmpl` are the same idea — one source resolving to `pbcopy` on
macOS and to `wl-copy` or `xclip` on Linux. That last choice is a runtime
`$WAYLAND_DISPLAY` check rather than a template condition, because the same
machine can run a Wayland or an X11 session, and neither over SSH. It also
requires `wl-copy` to exist: WSLg sets `$WAYLAND_DISPLAY` too, on machines
provisioned before wl-clipboard was added to the package list.

`~/.zshrc.local` is sourced last and stays outside chezmoi and git entirely,
for one-off tweaks. Anything that's a real, known-in-advance per-machine value
should go through templating instead.

## Why fzf is left entirely to the oh-my-zsh plugin

The `fzf` plugin runs `fzf --zsh` when fzf is >= 0.48, which sets up the key
bindings and `**` completion in one go, from the binary itself — no
distro-specific script path. Every distro the workstation-setup repo
supports ships a new enough fzf (Debian 13 has 0.60, Ubuntu 26.04 and Fedora
0.67, Arch 0.74), verified on Arch and Fedora by checking that `^R` is bound
to `fzf-history-widget` and `_fzf_complete` exists.

`.zshrc` used to also source the scripts from `/usr/share/doc/fzf/examples`
by hand. That path only exists on Debian and Ubuntu, where it loaded fzf a
second time; the belief behind it — that nothing else sources
`completion.zsh` — was true of the distro packages but missed the plugin.

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
