-- Must be set before lazy.nvim loads any plugin that maps <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")

-- Self-clones on first run, nothing to preinstall
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Every file under lua/plugins/ is auto-loaded as a spec. rocks is off
-- because nothing here needs luarocks-built native libs.
require("lazy").setup("plugins", {
  rocks = { enabled = false },
})
