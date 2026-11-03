-- =========================================================
-- User Configuration
-- =========================================================

require('config.options')   -- global options (loaded before plugins)
require('config.keymaps')   -- global key mappings
require('config.autocmds')  -- global autocommands

-- =========================================================
-- Plugin
-- =========================================================

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugin config
require('lazy').setup({ { import = 'plugins' } })  -- all package settings with lazy.nvim
require('util.autolcd')  -- automatically change local working directory for buffers
require('util.quick-closer')  -- quickly close tiny buffers by pressing `q` in normal mode

-- vim: set sw=2 et
