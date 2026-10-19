return {
	"jblandonsv/the-little-prince-themes.nvim",
	-- dir = "/Users/jaime/projects/the-little-prince-themes.nvim", -- TEMP: local checkout for testing; remove when pushed to GitHub
	lazy = true, -- load on startup so :colorscheme works out of the box
	priority = 1000,
	config = function()
		require("littleprince").setup({
			flavour = "prince", -- "prince" | "rose" | "fox" | "sheep"
			integrations = {
				telescope = true,
				gitsigns = true,
				treesitter_context = true,
				nvim_tree = true,
				neo_tree = true,
				which_key = true,
				indent_blankline = true,
				trouble = true,
				cmp = true,
				notify = true,
				lualine = true,
				alpha = true,
				flash = true,
				rainbow_delimiters = true,
				rainbow_indent = true,
				hop = true,
				leap = true,
				marks = true,
				lightspeed = true,
			},
		})
	end,
}
