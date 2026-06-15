return {
	{
		"skywind3000/asyncrun.vim",
		lazy = true,
	},
	{
		"habamax/vim-godot",
		ft = { "gd", "gdscript", "gdscript3", "gdshader", "tres", "tscn" },
		dependencies = { "skywind3000/asyncrun.vim" },
		init = function()
			-- OSX Godot executable path
			vim.g.godot_executable = "/Applications/Godot.app/Contents/MacOS/Godot"
		end,
		keys = {
			{ "<leader>gr", "<cmd>GodotRun<CR>", desc = "Godot Run main scene" },
			{ "<leader>gs", ":GodotRun ", desc = "Godot Select and run scene" },
			{ "<leader>gf", "<cmd>GodotRunFZF<CR>", desc = "Godot Run scene (FZF)" },
		},
	},
}
