-- This require to install netcat
-- Install netcat with Homebrew: `brew install netcat`
require("lspconfig").gdscript.setup({
	-- Comando para conectar con el servidor LSP de Godot usando netcat
	cmd = { "netcat", "localhost", "6005" },
	-- Tipos de archivo que activan este servidor LSP
	filetypes = { "gd", "gdscript", "gdscript3" },
	-- Función para encontrar la raíz del proyecto buscando project.godot
	root_dir = function()
		return vim.fs.dirname(vim.fs.find("project.godot", { upward = true })[1])
	end,
})
