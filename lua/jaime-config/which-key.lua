require("which-key").setup({})
require("which-key").register({
	f = { name = "file", f = { "<cmd>Telescope ffind_files<cr>", "Find File" } },
}, { prefix = "<leader>" })
