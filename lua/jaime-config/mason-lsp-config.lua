-- Extend the existing mason.nvim setup with the servers we want to install,
-- then enable them through the native vim.lsp API (Neovim 0.11+).
-- Names on the left are mason package names; names on the right are the LSP
-- server names vim.lsp.enable() expects.

local mason_to_lsp = {
	["lua-language-server"]   = "lua_ls",
	["apex-language-server"]  = "apex_ls",
	["css-lsp"]               = "cssls",
	["typescript-language-server"] = "ts_ls",
	["terraform-ls"]          = "terraformls",
	["tflint"]                = "tflint",
	["json-lsp"]              = "jsonls",
	["docker-langserver"]     = "dockerls",
	["eslint-lsp"]            = "eslint",
	["emmet-ls"]              = "emmet_ls",
	["html-lsp"]              = "html",
	["lwc-language-server"]   = "lwc_ls",
	["spectral-language-server"] = "spectral",
	["python-lsp-server"]     = "pylsp",
	["vue-language-server"]   = "vue_ls",
	["lemminx"]               = "lemminx",
	["yaml-language-server"]  = "yamlls",
}

require("mason").setup({
	ensure_installed = vim.tbl_keys(mason_to_lsp),
})

vim.lsp.enable({
	"lua_ls",
	"apex_ls",
	"cssls",
	"ts_ls",
	"terraformls",
	"tflint",
	"jsonls",
	"dockerls",
	"eslint",
	"emmet_ls",
	"html",
	"lwc_ls",
	"spectral",
	"pylsp",
	"vue_ls",
	"lemminx",
	"yamlls",
	"stylua",
})
