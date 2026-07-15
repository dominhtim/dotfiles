local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Ex<CR>", { desc = "Open file explorer (netrw)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, keep cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, keep cursor centered" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Highlight + Ctrl-C copies to the system clipboard, GUI-app style.
-- "+y" explicitly targets the system clipboard register — doesn't rely on
-- 'clipboard=unnamedplus' in options.lua staying set, so this keeps
-- working even if that ever changes. Only remapped in visual mode: this
-- gives up Ctrl-C's default "cancel visual mode" behavior specifically
-- while selecting, but Esc still does that same job.
map("v", "<C-c>", '"+y', { desc = "Copy selection to system clipboard" })
