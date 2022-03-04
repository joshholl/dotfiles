vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.api.nvim_command("packadd packer.nvim")

return require("packer").startup({
    function(use)
      -- Packer can manage itself
      use("wbthomason/packer.nvim")
      use("sainnhe/sonokai")
      use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim"}})
    end
})

