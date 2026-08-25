-- Fuzzy finder over files, text and buffers
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep (needs ripgrep)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Open buffers" },
  },
}
