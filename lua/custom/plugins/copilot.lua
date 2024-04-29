return {
  {
    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      lazy = false,
      opts = { suggestion = { auto_trigger = true, debounce = 150 } },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    opts = function(_, opts) end,
  },
}
