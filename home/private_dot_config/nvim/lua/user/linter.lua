local lint_status_ok, cmp = pcall(require, "lint")
if not lint_status_ok then
  return
end

require('lint').linters_by_ft = {
    typescript = {'eslint', }
}


vim.cmd [[
    augroup _linter
    autocmd!
    au BufWritePost <buffer> lua require('lint').try_lint()
  augroup end
]]