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

  {
    'Lilja/zellij.nvim',
    opts = {
      vimTmuxNavigatorKeybinds = false, -- Will set keybinds like <C-h> to left
    },
  },
}
