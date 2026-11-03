-- Language server configuration

local M = {}

function M.setup()
  local opts = { noremap = true, silent = true }
  local goto_error_prev = function()
    vim.diagnostic.jump({
      count = -1,
      wrap = false,
    })
  end
  local goto_error_next = function()
    vim.diagnostic.jump({
      count = 1,
      wrap = false,
    })
  end
  vim.keymap.set('n', '[e', goto_error_prev, opts)
  vim.keymap.set('n', ']e', goto_error_next, opts)
  vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)

  local on_attach = function(_, bufnr)
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- key mapping
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  end

  -- apply the same on_attach to every language server
  vim.lsp.config('*', { on_attach = on_attach })

  vim.api.nvim_create_user_command('Rename', function(opts)
    vim.lsp.buf.rename(opts.args)
  end, { nargs = 1 })

  local lsp_flags = {
    debounce_text_changes = 150,
  }

  -- spell check
  if vim.fn.executable('typos-lsp') > 0 then
    vim.lsp.enable('typos_lsp')
    vim.lsp.config('typos_lsp', {
      flags = lsp_flags,
    })
  end

  -- bash
  -- requires `shellcheck` or `shellharden` command to enable diagnostic
  if vim.fn.executable('bash-language-server') > 0 then
    vim.lsp.enable('bashls')
    vim.lsp.config('bashls', {
      flags = lsp_flags,
      filetypes = { 'sh', 'bash' },
    })
  end

  -- fsh
  -- requires `fish-lsp` command
  if vim.fn.executable('fish-lsp') > 0 then
    vim.lsp.enable('fish_lsp')
    vim.lsp.config('fish_lsp', {
      flags = lsp_flags,
      cmd = { 'fish-lsp', 'start' },
      filetypes = { 'fish' },
    })
  end

  -- c/cpp
  -- requires `clangd` included in `clang` package
  if vim.fn.executable('clangd') > 0 then
    vim.lsp.enable('clangd')
    vim.lsp.config('clangd', {
      flags = lsp_flags,
    })
  end

  -- elixir
  if vim.fn.executable('elixir-ls') > 0 then
    vim.lsp.enable('elixirls')
    vim.lsp.config('elixirls', {
      cmd = {'elixir-ls'}
    })
  end

  -- lua
  if vim.fn.executable('lua-language-server') > 0 then
    vim.lsp.enable('lua_ls')
    vim.lsp.config('lua_ls', {
      flags = lsp_flags,
      settings = {
        Lua = {
          runtime = {
            -- neovim embedded lua is LuaJIT
            version = 'LuaJIT',
          },
          diagnostics = {
            enable = true,
            -- ignore undefined error for `vim` global variable on nvim config
            globals = { 'vim' },
          },
          workspaces = {
            -- make the server aware of neovim runtime files
            library = vim.api.nvim_get_runtime_file('', true),
          },
          -- Do not send telemetry data
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end

  -- python
  if vim.fn.executable('pyright') > 0 then
    vim.lsp.enable('pyright')
    vim.lsp.config('pyright', {
      flags = lsp_flags,
    })
  end

  -- rust
  if vim.fn.executable('rust-analyzer') > 0 then
    vim.lsp.enable('rust_analyzer')
    vim.lsp.config('rust_analyzer', {
      flags = lsp_flags,
      settings = {
        -- server specific setting
        ['rust-analyzer'] = {}
      }
    })
  end
end

return M
