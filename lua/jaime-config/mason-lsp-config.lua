require("mason-lspconfig").setup({
	-- rust es manejado por el plugin rustacean
	ensure_installed = {
		"lua_ls",
		"apex_ls",
		"cssls",
		"vuels",
		"tsserver",
		"terraformls",
		"tflint",
		"jsonls",
		"dockerls",
		"eslint",
		"emmet_ls",
		"html",
		"lwc_ls",
		"spectral",
		"ruff_lsp",
		"pylsp",
		"volar",
		"lemminx",
		"yamlls",
	},
})
