return {
  {
    'stevedylandev/ansi-nvim',
    priority = 1000, -- load the colorscheme before other start plugins
    config = function()
      vim.cmd([[colorscheme ansi]])
      vim.opt.termguicolors = false
    end,
  },
}
