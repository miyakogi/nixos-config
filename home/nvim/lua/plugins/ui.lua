return {
  -- highlight current word
  {
    'nvim-mini/mini.cursorword',
    config = function()
      require("mini.cursorword").setup({
        delay = 30,
      })
    end,
  },

  -- notification
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
      })

      require('notify').setup({
        background_colour = '#000000',
      })
    end,
  },

  {
    'folke/which-key.nvim',
    tag = 'stable',
    event = 'VeryLazy',
    opts = {
    },
    config = function()
      require('which-key').setup({
        preset = 'helix',
        delay = 10,
        triggers = {
          { '<auto>', mode = 'nixsotc' },
          { 's', mode = { 'n', 'v' } },  -- for mini.surround
        },
        plugins = {
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            window = true,
            nav = true,
            z = true,
            g = true,
          },
        },
      })
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
  },

  -- status line
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
      },
    },
    config = function()
      require('lualine').setup({
        options = {
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
      })
    end,
  },
}
