require("mason-tool-installer").setup({

	-- a list of all tools you want to ensure are installed upon
	-- start
	ensure_installed = {
		"lua-language-server",
		"stylua",
		"prettier",
		"curlylint",
	},
})
