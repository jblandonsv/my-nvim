vim.keymap.set('n', '<leader>db', ":DapToggleBreakpoint<cr>")
vim.keymap.set('n', '<leader>dr', ":DapContinue<cr>")
vim.fn.sign_define('DapBreakpoint', {text='🔸', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
