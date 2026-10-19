vim.lsp.config("gdscript", {
	cmd = { "netcat", "localhost", "6005" },
	filetypes = { "gd", "gdscript", "gdscript3" },
	root_dir = function()
		return vim.fs.dirname(vim.fs.find("project.godot", { upward = true })[1])
	end,
})
vim.lsp.enable("gdscript")
