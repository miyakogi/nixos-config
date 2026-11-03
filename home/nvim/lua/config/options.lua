-- Global options and startup globals, loaded before plugins.

-- Disable default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_LogiPat = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1

-- from: https://zenn.dev/kawarimidoll/articles/8172a4c29a6653
vim.g.did_install_default_menus = 1
vim.g.loaded_2html_plugin       = 1
vim.g.loaded_man                = 1
vim.g.loaded_matchit            = 1
vim.g.loaded_matchparen         = 1
vim.g.loaded_remote_plugins     = 1
vim.g.loaded_shada_plugin       = 1
vim.g.loaded_spellfile_plugin   = 1
vim.g.loaded_tutor_mode_plugin  = 1
vim.g.skip_loading_mswin        = 1

-- Leader key, must be set before plugins are loaded
vim.g.mapleader = ","

-- Reload when file modified outside nvim
vim.opt.autoread = true

-- Disable default files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupdir = ''
vim.opt.undofile = false
vim.opt.swapfile = false

-- Background buffer setting
vim.opt.hidden = true

-- Wildmenu (enhanced command-line completion)
vim.opt.wildmenu = true
vim.opt.wildmode:append({'longest:full', 'full'})

-- Virtual edit (enable visual block to select over eol)
vim.opt.virtualedit:append({'block'})

-- Format options
vim.opt.nrformats:remove({'octal'})
vim.opt.joinspaces = false

-- End of line action
vim.opt.textwidth = 0  -- disable text wrap
vim.opt.backspace = {'indent', 'eol', 'start'}

-- Ignore unnecessary files from completion
vim.opt.wildignore = {
  '*.sw?',  -- vim swap file
  '*.bak', '*.?~', '*.??~', '*.???~', '*.~',  -- backup files
  '*.pyc',  -- python byte code
}

-- Help setting
vim.opt.keywordprg = ':help'
vim.opt.helplang = {'ja', 'en'}

-- Improve timeout
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50

-- Visual bell
vim.opt.visualbell = true
vim.opt.errorbells = false

-- Mouse
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup'

-- Display setting
vim.opt.scrolloff = 5  -- min lines of up/bottom of cursor
vim.opt.sidescrolloff = 5  -- min cols of left/right of cursor
vim.opt.wrap = true  -- wrap long line (only on display)
vim.opt.number = false  -- disable number sign col
vim.opt.showcmd = true  -- show some command in the end of cmd win
vim.opt.report = 2  -- threshold for reporting number of lines changed
vim.opt.ruler = false

-- Spell check
vim.opt.spell = true  -- enable spell check and spellsitter by default
vim.opt.spelllang:append({'cjk'})  -- disable spell check on multibyte characters
vim.opt.spelloptions:append({'camel'})  -- Enable spell check for camel case words

-- Invisible chars
vim.opt.list = true  -- display invisible chars
vim.opt.listchars = {tab = '| ', trail = '_'}
vim.opt.fillchars:append({vert = '┃'})
vim.opt.linebreak = false
vim.opt.shiftround = true -- round indent to multiple of 'shiftwidth'
vim.opt.showbreak = '󱞩 '
vim.opt.breakindent = true
vim.opt.ambiwidth = 'single'

-- Window setting
vim.opt.cmdheight = 1  -- always show status-line, command-line is shown by noice.nvim
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.equalalways = false  -- disable to set all windows to the same size aster split/close

-- Folding setting
vim.opt.foldmethod = 'marker'

-- Search setting
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.history = 10000
vim.opt.wrapscan = false

-- Tab/indent setting (global)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cindent = false
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Rendering setting
vim.opt.lazyredraw = false

-- Color setting
vim.opt.termguicolors = true

-- Wrap start/end of lines by cursor keys (mappings live in config/keymaps)
vim.opt.whichwrap = 'b,s,<,>,[,]'

-- Always show tab line
vim.opt.showtabline = 1
