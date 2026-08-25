-- Replaces vim-airline
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "gruvbox",
      -- Everything below keeps the statusline to characters any font has.
      --
      -- The default statusline needs a Nerd Font in the *terminal* — fonts
      -- resolve on whatever machine you're sitting at, so SSH'ing into a
      -- box renders its nvim in the local terminal's font, and no amount
      -- of installing fonts on the server changes that. Without one you
      -- get replacement boxes rather than glyphs.
      --
      -- icons_enabled covers the two components that carry glyphs:
      -- fileformat (U+E712 for unix) falls back to the literal "unix",
      -- and filetype stops asking nvim-web-devicons for a file icon.
      icons_enabled = false,
      -- icons_enabled does *not* reach the separators — they're drawn from
      -- these options, and both default to powerline glyphs (U+E0B0-E0B3)
      -- that need the same font. Blanking the section separators and using
      -- a plain bar between components is lualine's own no-Nerd-Font
      -- recipe, and without it the setting above only half-works.
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
  },
}
