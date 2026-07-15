local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Ex<CR>", { desc = "Open file explorer (netrw)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, keep cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, keep cursor centered" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
