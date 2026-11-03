-- Global key mappings

-- ======== Normal/Visual Cursor Move ========
-- Wrap start/end of lines by h and l keys
vim.keymap.set('n', 'h', '<Left>')
vim.keymap.set('n', 'l', '<Right>')
vim.keymap.set('x', 'h', '<Left>')
vim.keymap.set('x', 'l', '<Right>')

-- Move up/down with display lines
vim.keymap.set({'n', 'x'}, 'j', 'gj', { silent = true })
vim.keymap.set({'n', 'x'}, 'k', 'gk', { silent = true })
vim.keymap.set({'n', 'x'}, 'gj', 'j', { silent = true })
vim.keymap.set({'n', 'x'}, 'gk', 'k', { silent = true })
vim.keymap.set({'n', 'x'}, '<Down>', 'g<Down>', { silent = true })
vim.keymap.set({'n', 'x'}, '<Up>', 'g<Up>', { silent = true })
vim.keymap.set({'n', 'x'}, 'g<Down>', '<Down>', { silent = true })
vim.keymap.set({'n', 'x'}, 'g<Up>', '<Up>', { silent = true })

-- Move to start/end of lines
vim.keymap.set({'n', 'x'}, 'gh', '^', { silent = true })  -- from helix-editor
vim.keymap.set({'n', 'x'}, 'gs', '0', { silent = true })  -- from helix-editor
vim.keymap.set({'n', 'x'}, 'gl', '$', { silent = true })  -- from helix-editor

-- Go to file end
vim.keymap.set({'n', 'x'}, 'ge', 'G', { silent = true }) -- from helix-editor

-- Redo
vim.keymap.set('n', 'U', '<C-r>')  -- from helix-editor

-- ======== Insert/Command Cursor Move ========
vim.keymap.set('i', '<C-a>', '<C-o>_')
vim.keymap.set('i', '<C-e>', '<End>')
vim.keymap.set('i', '<C-f>', '<Right>')
vim.keymap.set('i', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-n>', '<Down>')
vim.keymap.set('c', '<C-p>', '<Up>')
vim.keymap.set('c', '<Down>', '<C-n>')
vim.keymap.set('c', '<Up>', '<C-p>')

-- ======== Tab Control ========
vim.keymap.set('n', '<C-j>', 'gt')
vim.keymap.set('n', '<C-k>', 'gT')

-- ======== Misc ========
-- Disable dangerous/unnecessary keys
vim.keymap.set('n', 'ZZ', '<Nop>')  -- danger
vim.keymap.set('n', 'ZQ', '<Nop>')  -- danger
vim.keymap.set('n', '<F1>', '<Nop>')  -- show help

-- Cut right of cursor
vim.keymap.set('i', '<C-k>', '<C-g>u<C-\\><C-o>D')
vim.keymap.set('c', '<C-k>', '<C-g>u<C-\\><C-o>D')

-- Copy/Paset/Cut from/to clipboard
vim.keymap.set('i', '<C-v>', '<C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>', { silent = true })
vim.keymap.set('i', '<A-v>', '<C-v>')
vim.keymap.set('i', '<C-z>', '<C-v>')
vim.keymap.set('c', '<C-v>', '<C-r>+')
vim.keymap.set('c', '<A-v>', '<C-v>')
vim.keymap.set('c', '<C-z>', '<C-v>')
vim.keymap.set('x', '<C-c>', '"+y')
vim.keymap.set('x', '<C-x>', '"+d')
vim.keymap.set('x', '<C-v>', '"+p')

vim .keymap.set('x', '<Space>y', '"+y')  -- from helix-editor
vim .keymap.set('n', '<Space>p', '"+p')  -- from helix-editor
vim .keymap.set('n', '<Space>P', '"+P')  -- from helix-editor

-- Use C-q to do what C-v used to do
vim.keymap.set('n', '<C-q>', '<C-v>')

-- ======== Keyd Fixup ========
vim.keymap.set('i', '<C-BS>', '<C-w>')

-- ======== Command Mapping ========

-- Clear highlighting search word
vim.keymap.set('n', '<Esc><Esc>', ':<C-u>nohl<CR><C-l>')
vim.keymap.set('n', '<C-l>', ':<C-u>nohl<CR><C-l>')