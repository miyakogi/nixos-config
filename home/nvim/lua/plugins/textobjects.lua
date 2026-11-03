return {
  -- wiw (support `snake_case`, `CamelCase`, `CAPITAL_CASE`, and so on...)
  {
    'rhysd/vim-textobj-wiw',
    dependencies = {
      { 'kana/vim-textobj-user' },
    },
    init = function()
      vim.g.textobj_wiw_no_default_key_mappings = 1
    end,
    config = function()
      vim.keymap.set({'x', 'o'}, 'au', '<Plug>(textobj-wiw-a)', { noremap = false })
      vim.keymap.set({'x', 'o'}, 'iu', '<Plug>(textobj-wiw-i)', { noremap = false })
    end,
  },

  -- parameter (support function parameters)
  {
    'sgur/vim-textobj-parameter',
    dependencies = {
      { 'kana/vim-textobj-user' },
    },
  },
}
