-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local function pathIsTestFile(path)
  return string.match(path, '.*%.spec%.ts')
end

local function fileExists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function getCurrentTestFile()
  local bufferPath = vim.api.nvim_buf_get_name(0)
  local isTestFile = pathIsTestFile(bufferPath)

  if isTestFile then
    return bufferPath
  else
    local testFile = string.gsub(bufferPath, '%.ts', '%.spec%.ts')
    if fileExists(testFile) then
      return testFile
    end
  end
end

local function getRootFolder(bufferPath)
  local backendPath = string.match(bufferPath, '.*backend')
  if backendPath then
    return backendPath
  end

  local appPatientPath = string.match(bufferPath, '.*app%-patient/patient')
  if appPatientPath then
    return appPatientPath
  end

  local appManagePath = string.match(bufferPath, '.*app%-manage/manage')
  if appManagePath then
    return appManagePath
  end

  local sharedPath = string.match(bufferPath, '.*shared')
  if sharedPath then
    return sharedPath
  end

  local regionPath = string.match(bufferPath, '.*region')
  if regionPath then
    return regionPath
  end

  local globalPath = string.match(bufferPath, '.*global')
  if globalPath then
    return globalPath
  end

  local dentallyMockPath = string.match(bufferPath, '.*dentally%-mock')
  if dentallyMockPath then
    return dentallyMockPath
  end

  print 'No root folder found!'
end

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
      required_changes = 20,
    },
  },

  {
    'dstein64/nvim-scrollview',
    opts = {
      signs_on_startup = { 'all' },
      -- diagnostics_severities = { vim.diagnostic.severity.ERROR },
    },
  },

  {
    'yutkat/git-rebase-auto-diff.nvim',
    ft = { 'gitrebase' },
    config = function()
      require('git-rebase-auto-diff').setup()
    end,
  },

  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    config = function()
      require('telescope').load_extension 'smart_open'
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    },
  },

  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-jest',
    },
    config = function()
      require('neotest').setup {
        log_level = 0,
        adapters = {
          require 'neotest-jest' {
            jestCommand = require('neotest-jest.jest-util').getJestCommand(vim.fn.expand '%:p:h') .. ' --watch',
            jestConfigFile = 'custom.jest.config.ts',
            env = { CI = true },
            cwd = function(path)
              return getRootFolder(path)
            end,
          },
        },
      }
    end,
    keys = {
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run tests',
      },
      {
        '<leader>tl',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[T]est [L]ist',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(getCurrentTestFile())
        end,
        desc = 'Run file tests',
      },
      {
        '<leader>ts',
        function()
          require('neotest').run.run(getRootFolder(vim.fn.expand '%'))
        end,
        desc = 'Run suite tests',
      },
      {
        '<leader>td',
        '<CMD>NeotestDebug<CR>',
        desc = 'Debug tests',
      },
      {
        '<leader>tc',
        '<CMD>NeotestClear<CR>',
        desc = 'Clear tests',
      },
    },
  },

  {
    'Asheq/close-buffers.vim',
    keys = {
      {
        '<leader>bdt',
        ':Bdelete this<CR>',
        desc = '[B]uffer [D]elete [T]his',
      },
      {
        '<leader>bda',
        ':Bdelete all<CR>',
        desc = '[B]uffer [D]elete [A]ll',
      },
      {
        '<leader>bdo',
        ':Bdelete other<CR>',
        desc = '[B]uffer [D]elete [O]ther',
      },
    },
  },

  {
    'coderifous/textobj-word-column.vim',
  },

  {
    'TamaMcGlinn/quickfixdd',
  },

  {
    'almo7aya/openingh.nvim',
  },
}
