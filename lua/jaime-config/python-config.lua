require('lspconfig').pylsp.setup {
  settings = {
    -- configure plugins in pylsp
    pylsp = {
      plugins = {
        flake8 = {enabled = true},
        pyflakes = {enabled = false},
        pylint = {enabled = false},
        autopep8 = {enabled = false},
        mccabe = {enabled = false},
        pycodestyle = {enabled = false},
        yapf = {enabled = false},
        ruff = {enabled = false}
      },
    },
  },
}