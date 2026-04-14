-- mason-lsp-config configuration
-- Automatically installs and manages LSP servers for various languages and frameworks
-- Servers listed here will be installed automatically if not present

require("mason-lspconfig").setup({
	-- rust es manejado por el plugin rustacean
	ensure_installed = {
		"lua_ls",
		"apex_ls",
		"cssls",
		"vuels",
		-- "tsserver", -- replaced by ts_ls
		"ts_ls",
		"terraformls",
		"tflint",
		"jsonls",
		"dockerls",
		"eslint",
		"emmet_ls",
		"html",
		"lwc_ls", -- Salesforce Lightning Web Components
		"spectral", -- OpenAPI linter
		-- "ruff_lsp", -- replaced by pylsp
		"pylsp",
		"volar", -- Vue.js
		"lemminx", -- XML
		"yamlls",
	},
})
