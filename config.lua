lvim.transparent_window = true

-- basic
lvim.format_on_save = true
vim.wo.colorcolumn = '81,101,121'

-- clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('v', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
vim.keymap.set('v', '<leader>P', '"+P')

-- nvimtree
lvim.builtin.nvimtree.setup.view.adaptive_size = true
lvim.builtin.nvimtree.setup.view.width = 100

-- plugins
lvim.plugins = {
  "leoluz/nvim-dap-go",
  {
    "nvim-neotest/neotest",
    dependencies = {
      -- adapters
      "nvim-neotest/neotest-go",
    },
    opts = {
      -- adapter config
      adapters = {
        ["neotest-go"] = {
          args = { "-tags=unit,integration,utest,itest" },
        },
      },
    },
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message
                :gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
  },

  -- theme
  "bluz71/vim-moonfly-colors",
}
lvim.colorscheme = "moonfly"

-- tab navigation
lvim.keys.normal_mode["<A-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<A-h>"] = ":BufferLineCyclePrev<CR>"
-- open diagostic
lvim.keys.normal_mode["<C-e>"] = "<cmd>lua vim.diagnostic.open_float()<cr>"

-- neotest keymap TODO: move to a subdirectory
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
