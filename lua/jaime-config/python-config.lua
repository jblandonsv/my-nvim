vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				ruff = { enabled = false },
				flake8 = { enabled = true },
				pyflakes = { enabled = false },
				pylint = { enabled = false },
				autopep8 = { enabled = false },
				mccabe = { enabled = false },
				pycodestyle = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
})
vim.lsp.enable("pylsp")
