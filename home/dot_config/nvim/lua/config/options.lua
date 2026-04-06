local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes"

-- Indentation (vim-sleuth will override per filetype)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Appearance
opt.termguicolors = true
opt.cursorline = true
opt.showmode = false
opt.wrap = true
opt.linebreak = true
opt.conceallevel = 0
opt.pumheight = 10
opt.showtabline = 2
opt.cmdheight = 1

-- Files / undo
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Editing
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.fileencoding = "utf-8"
opt.completeopt = { "menuone", "noselect" }

-- Disable auto-comment continuation
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.opt.shortmess:append("c")
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd("set iskeyword+=-")
