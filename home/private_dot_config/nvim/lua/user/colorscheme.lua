
vim.g["sonokai_style"] = 'andromeda'
vim.g["sonokai_enable_italic"] = 1
vim.g["sonokai_disable_italic_comment"] = 1

vim.cmd [[
try
colorscheme sonokai
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
