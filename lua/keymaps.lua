-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Terminal/Toggle/Test
vim.keymap.set('n', '<Leader>to', function()
  require('functions').TmuxOpen()
end, { desc = '[T]mux [O]pen' })

vim.keymap.set('n', '<Leader>tr', function()
  require('functions').TmuxRepeat()
end, { desc = '[T]mux [R]epeat' })

vim.keymap.set('n', '<Leader>ta', function()
  require('functions').TmuxTestAll()
end, { desc = '[T]est [A]ll' })

vim.keymap.set('n', '<Leader>tf', function()
  require('functions').TmuxTestFile()
end, { desc = '[T]est [F]ile' })

vim.keymap.set('n', '<Leader>tn', function()
  require('functions').TmuxTestNearest()
end, { desc = '[T]est [N]earest' })

vim.keymap.set('n', '<Leader>tt', function()
  require('functions').ToggleTest()
end, { desc = '[T]oggle [T]est' })

vim.keymap.set('n', '<Leader>th', function()
  require('functions').ToggleHtml()
end, { desc = '[T]oggle [H]tml' })

-- git signs
vim.keymap.set('n', ']g', function()
  require('gitsigns').next_hunk()
end, { desc = 'Next Git hunk' })
vim.keymap.set('n', '[g', function()
  require('gitsigns').prev_hunk()
end, { desc = 'Previous Git hunk' })
vim.keymap.set('n', '<Leader>gl', function()
  require('gitsigns').blame_line()
end, { desc = 'View Git blame' })
vim.keymap.set('n', '<Leader>gL', function()
  require('gitsigns').blame_line { full = true }
end, { desc = 'View full Git blame' })
vim.keymap.set('n', '<Leader>gp', function()
  require('gitsigns').preview_hunk_inline()
end, { desc = 'Preview Git hunk' })
vim.keymap.set('n', '<Leader>gh', function()
  require('gitsigns').reset_hunk()
end, { desc = 'Reset Git hunk' })
vim.keymap.set('n', '<Leader>gr', function()
  require('gitsigns').reset_buffer()
end, { desc = 'Reset Git buffer' })
vim.keymap.set('n', '<Leader>gs', function()
  require('gitsigns').stage_hunk()
end, { desc = 'Stage Git hunk' })
vim.keymap.set('n', '<Leader>gS', function()
  require('gitsigns').stage_buffer()
end, { desc = 'Stage Git buffer' })
vim.keymap.set('n', '<Leader>gu', function()
  require('gitsigns').undo_stage_hunk()
end, { desc = 'Unstage Git hunk' })
vim.keymap.set('n', '<Leader>gd', function()
  require('gitsigns').diffthis()
end, { desc = 'View Git diff' })

-- Other
vim.keymap.set('n', '<Leader>gg', function()
  require('functions').ShortGuid()
end, { desc = '[G]enerate [G]uid' })

-- vim: ts=2 sts=2 sw=2 et
