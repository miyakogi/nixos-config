-- completion
return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'f3fora/cmp-spell' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'L3MON4D3/LuaSnip' },
      { 'onsails/lspkind.nvim'},
    },
    lazy = true,
    event = 'InsertEnter',
    init = function()
      -- nvim-cmp requires this; `setup` was a packer.nvim field ignored by lazy.nvim
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
    end,
    config = function()
      -- setup nvim-cmp
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')

      cmp.setup({
        -- snippet
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },

        -- mapping
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-x>'] = cmp.mapping.complete(),
          ['<C-Space>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }
          ),
        }),

        -- sources
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
          { name = 'spell' },
        }),

        -- lsp icon and text
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show symbol and text
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function (_, vim_item)
              return vim_item
            end
          })
        },
      })
    end,
  },

  -- snippet
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      { 'miyakogi/vim-snippets' },
    },
    build = 'make install_jsregexp',
    lazy = true,
    config = function()
      require('luasnip.loaders.from_snipmate').lazy_load()
    end,
  },
}
