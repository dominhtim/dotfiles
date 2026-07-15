return {
  { "tpope/vim-fugitive" },

  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "numToStr/Comment.nvim", event = "VeryLazy", config = true },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },
}
