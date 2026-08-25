-- Statusline. Drawn without Nerd Font glyphs — see CLAUDE.md.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "gruvbox",
      -- Drops the glyphs from fileformat and filetype.
      icons_enabled = false,
      -- Separators are not covered by icons_enabled and default to
      -- powerline glyphs, so they have to be replaced separately.
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
  },
}
