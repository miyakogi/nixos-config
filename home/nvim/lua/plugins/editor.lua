return {
  -- smartchr
  {
    'kana/vim-smartchr',
    lazy = true,
    event = 'InsertEnter',
    init = function()  -- Define autocmd at setup, as `config` is called after entering insert-mode
      -- filetype specific keymappings
      vim.api.nvim_create_augroup('smartchr', {})

      -- python
      vim.api.nvim_create_autocmd(
        'bufenter',
        {
          group = 'smartchr',
          pattern = '*.py',
          callback = function()
            vim.cmd([[
              inoremap <expr> <buffer> = smartchr#loop(' = ', '=', ' == ', '==')
            ]])
          end,
        }
      )

      -- rust
      vim.api.nvim_create_autocmd(
        'bufenter',
        {
          group = 'smartchr',
          pattern = '*.rs',
          callback = function()
            vim.cmd([[
              inoremap <expr> <buffer> <C-l> smartchr#loop(' -> ', ' => ')
              inoremap <expr> <buffer> = smartchr#loop(' = ', '=', ' == ', '==')
            ]])
          end,
        }
      )

      -- javascript
      vim.api.nvim_create_autocmd(
        'bufenter',
        {
          group = 'smartchr',
          pattern = '*.js',
          callback = function()
            vim.cmd([[
              inoremap <expr> <buffer> = smartchr#loop(' = ', '=', ' == ', ' === ')
            ]])
          end,
        }
      )
    end,
    config = function()
      -- globally set `,`
      --vim.keymap.set('i', ',', function() vim.fn['smartchr#loop'](', ', ',') end, { expr = true, noremap = true })
      -- `vim.keymap.set` does not work...
      vim.cmd([[
        inoremap <expr> , smartchr#loop(', ', ',')
      ]])
    end,
  },

  -- auto surrounding/pairing
  {
    'windwp/nvim-autopairs',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      require'nvim-autopairs'.setup({
        map_cr = true,
        map_c_h = true,
      })

      -- disable autopair for `[[]]`
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      npairs.add_rule(Rule('[[', '', 'markdown'))
    end,
  },

  -- surround (parenthesis/quote/tab/etc...) control
  {
    'nvim-mini/mini.surround',
    config = function()
      require('mini.surround').setup({})
    end,
  },

  -- abbreviation
  {
    'tpope/vim-abolish',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      vim.cmd([[
        :Abolish teh the
        :Abolish fro for
        :Abolish sefl self
        :Abolish strign string
        :Abolish tokne{,s} token{}
      ]])
    end
  },

  -- open the last-edited place
  {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup({})
    end,
  },
}
