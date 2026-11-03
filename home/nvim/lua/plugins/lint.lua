return {
  -- linter
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        elixir = {
          'credo',
        },
        python = {
          'ruff',
        },
      }

      vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'TextChangedI', 'BufRead', 'BufWrite' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  -- code runner
  {
    'michaelb/sniprun',
    branch = 'master',

    build = 'sh install.sh',
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require('sniprun').setup({
      -- your options
      })
      vim.api.nvim_set_keymap('v', '<leader>r', '<Plug>SnipRun', {silent = true})
      vim.api.nvim_set_keymap('n', '<leader>c', '<Plug>SnipClose', {silent = true})
    end,
  },
}