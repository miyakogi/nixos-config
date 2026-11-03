-- misc
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = { enabled = true },
      -- explorer = { enabled = true },
      image = { enabled = true },
      indent = {
        enabled = true,
        animate = {
          duration = {
            steps = 25,
            total = 70,
          },
        },
      },
      picker = {
        enabled = true,
      },
      quickfile = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = {
            steps = 25,
            total = 100,
          },
        },
        animate_repeat = {
          duration = {
            steps = 10,
            total = 50,
          },
        },
      },
      statuscolumn = { enabled = true },
    },
    keys = {
      -- picker
      { '<Leader>ff', function() Snacks.picker.files() end, desc = 'Find files' },
      { '<Leader>fg', function() Snacks.picker.git_files() end, desc = 'Find git files' },
      { '<Leader>fm', function() Snacks.picker.recent() end, desc = 'Recent files' },
      { '<Space>e', function() Snacks.picker.smart() end, desc = 'Smart find files' },
      { '<Space>f', function() Snacks.picker.smart() end, desc = 'Smart find files' },
    },
  },
}
