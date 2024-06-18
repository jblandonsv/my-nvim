require('lspconfig').pylsp.setup {
  settings = {
    -- configure plugins in pylsp
    pylsp = {
      plugins = {
        ruff = {enabled = false},
        flake8 = {enabled = false},
        pyflakes = {enabled = false},
        pylint = {enabled = false},
        autopep8 = {enabled = false},
        mccabe = {enabled = false},
        pycodestyle = {enabled = false},
        yapf = {enabled = false}
      },
    },
  },
}
