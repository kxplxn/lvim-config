vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

local opts = {
  settings = {
    gopls = {
      buildFlags = {
        "-tags=unit,integration"
      }
    }
  }
}

require("lvim.lsp.manager").setup("gopls", opts)
