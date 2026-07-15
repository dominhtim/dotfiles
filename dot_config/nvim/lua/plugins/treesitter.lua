-- Real syntax-aware highlighting/indenting, not regex-based like classic Vim.
-- Pinned to `master` on purpose: nvim-treesitter's default branch is now
-- `main`, a complete, incompatible rewrite that removed
-- nvim-treesitter.configs (and ensure_installed/highlight/indent options)
-- entirely. `master` is frozen but the maintainers explicitly kept it
-- available for backward compatibility rather than deleting it.
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
