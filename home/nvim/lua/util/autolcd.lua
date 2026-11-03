-- Automatically Change Local Working Directory for Buffers

local function autolcd()
  local dir = vim.fn.expand('%:p:h')
  if vim.fn.isdirectory(dir) == 1 then
    vim.cmd.lcd(vim.fn.fnameescape(dir))
  end
end

vim.api.nvim_create_augroup('autolcd', {})
vim.api.nvim_create_autocmd(
  'bufenter',
  {
    group = 'autolcd',
    callback = autolcd,
  }
)
