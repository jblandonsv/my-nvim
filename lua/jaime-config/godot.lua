-- This require to install netcat
-- Install netcat with Homebrew: `brew install netcat`
require("lspconfig").gdscript.setup({
	cmd = { "netcat", "localhost", "6005" },
	filetypes = { "gd", "gdscript", "gdscript3" },
	root_dir = function()
		return vim.fs.dirname(vim.fs.find("project.godot", { upward = true })[1])
	end,
})
