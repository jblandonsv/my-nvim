vim.g.mapleader = " "

require("jaime-config.lazy")
require("jaime-config.remaps")
require("jaime-config.lsp-zero")
require("jaime-config.theme")
require("jaime-config.telescope")

require("jaime-config.python-config")
require("jaime-config.rust-tools")
require("jaime-config.lualine")
require("jaime-config.crates")

require("dap-python").setup("/Users/jaime/debug/bin/python")
