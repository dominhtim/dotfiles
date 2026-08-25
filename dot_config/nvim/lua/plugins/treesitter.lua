-- Syntax-aware highlighting and indenting. Pinned to `master` on purpose:
-- `main` is an incompatible rewrite — see CLAUDE.md.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "bash", "python", "markdown", "yaml", "json" },
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
