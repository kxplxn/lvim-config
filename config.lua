-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- basic
lvim.format_on_save = true
vim.wo.colorcolumn = '81'

-- clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('v', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
vim.keymap.set('v', '<leader>P', '"+P')

-- nvimtree
lvim.builtin.nvimtree.setup.view.adaptive_size = true
lvim.builtin.nvimtree.setup.view.width = 90

-- plugins
lvim.plugins = {
  -- TODO: figure out build tags for neotest?
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
      -- Your other test adapters here
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        -- your neotest config here
        adapters = {
          require("neotest-go"),
        },
      })
    end,
  }
}

-- keymap
lvim.keys.normal_mode["<A-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<A-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-k>"] = "<cmd>lua vim.diagnostic.open_float()<cr>"

local wk = require("which-key")
wk.register({
  t = {
    name = "neotest",
    t = { "<cmd>lua require('neotest').run.run()<cr>", "Test Function" },
    f = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test File" },
    d = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%:h')})<cr>", "Test Directory" },
    s = { "<cmd>lua require('neotest').run.run({vim.fn.getcwd()})<cr>", "Test Project" },
    S = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" },
  },
})
