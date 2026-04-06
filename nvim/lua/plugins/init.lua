-- Bootstrap lazy.nvim
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

require("lazy").setup({
  spec = {
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.treesitter" },
    { import = "plugins.telescope" },
    { import = "plugins.git" },
    { import = "plugins.cmp" },
    { import = "plugins.lsp" },
    { import = "plugins.scala" },
    { import = "plugins.java" },
  },
  ui = { border = "rounded" },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
