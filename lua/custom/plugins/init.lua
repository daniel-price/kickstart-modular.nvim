-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'stevearc/oil.nvim',
    opts = {},
    keys = {
      {
        '-',
        '<CMD>Oil<CR>',
        desc = 'Open Oil',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- {
  --   'Lilja/zellij.nvim',
  --   opts = {},
  -- },
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }

      vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    enabled = vim.fn.executable 'git' == 1,
    opts = {},
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      root_dir = require('lspconfig.util').root_pattern('sst.config.ts', 'tsconfig.json', 'package.json', 'jsconfig.json', '.git'),
    },
  },
  {
    'redve-dev/neovim-git-reminder',
    dependencies = {
      'rcarriga/nvim-notify',
    },
    opts = {
      required_changes = 5,
    },
  },
}
