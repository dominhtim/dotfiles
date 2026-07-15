-- Leader must be set before lazy.nvim loads any plugins that map <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")

-- Bootstrap lazy.nvim (self-clones on first run, nothing to preinstall)
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

-- Every file under lua/plugins/ is auto-loaded as a plugin spec.
-- rocks.enabled = false: nothing here needs luarocks-built native libs,
-- so this just silences a cosmetic checkhealth warning rather than
-- leaving it there to ignore every time.
require("lazy").setup("plugins", {
  rocks = { enabled = false },
})
