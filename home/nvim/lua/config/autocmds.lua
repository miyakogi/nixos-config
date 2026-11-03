-- Global autocommands

-- Create default auto group
vim.api.nvim_create_augroup('init', {})

-- Adjust format options on every buffer
vim.api.nvim_create_autocmd('bufenter', {
  group = 'init',
  pattern = {'*'},
  callback = function()
    vim.opt_local.formatoptions:remove('or')
    vim.opt_local.formatoptions:append('Mj')
  end,
})

-- Fix: back to original cursor shape on some terminal
local term = vim.env.TERM
if term == "foot" or term == "alacritty" or term == "wezterm" or term == "xterm-rio" then
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function ()
      vim.opt.guicursor = ""
      vim.fn.chansend(vim.v.stderr, "\x1b[ q")
    end
  })
end
