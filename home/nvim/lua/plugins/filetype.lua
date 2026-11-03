return {
  -- elixir
  {
    'elixir-editors/vim-elixir',
    ft = 'elixir',
  },

  -- input method (fcitx/fcitx5) control
  {
    'h-hg/fcitx.nvim',
    lazy = true,
    event = 'InsertEnter',
  },
}
