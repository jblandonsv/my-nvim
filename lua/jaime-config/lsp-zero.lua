local lsp = require("lsp-zero")

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			telemetry = { enable = false },
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.stdpath("config") .. "/lua",
				},
			},
		},
	},
})

vim.lsp.config("stylua", {
	cmd = { "stylua", "--check", "--lsp" },
	filetypes = { "lua" },
	settings = {},
})

vim.lsp.config("vue_ls", {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	settings = {
		volar = {
			server = {
				path = "",
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "stylua", "vue_ls" })
