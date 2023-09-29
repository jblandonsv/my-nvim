local pythondapconfig = require("dap-python")
vim.keymap.set('n', '<leader>dpt', pythondapconfig.test_method, {})
