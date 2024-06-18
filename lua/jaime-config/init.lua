vim.g.mapleader = " "

require("jaime-config.lazy")
require("jaime-config.remaps")
require("jaime-config.lsp-zero")
require("jaime-config.theme")
require("jaime-config.telescope")

require("jaime-config.mason-config")
require("jaime-config.mason-lsp-config")
require("jaime-config.mason-tools-installer-config")
require("jaime-config.python-config")
require("jaime-config.rustaceanvim")
require("jaime-config.lualine")
require("jaime-config.crates")
require("jaime-config.diagnostics")

require("jaime-config.apex-config")
require("jaime-config.aerial")
require("jaime-config.startup")

require("dap-python").setup("/Users/jaime/debug/bin/python")
require("toggleterm").setup({})
require("jaime-config.nvim-dap-js")
