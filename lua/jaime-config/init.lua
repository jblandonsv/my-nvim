vim.g.mapleader = " "

require("jaime-config.lazy")
require("jaime-config.remaps")
require("jaime-config.lsp-zero")
require("jaime-config.theme")

require("dap-python").setup("/Users/jaime/debug/bin/python")
