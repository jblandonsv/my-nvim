return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				apex = { "prettier" },
				cls = { "prettier" },
				st = { "prettier" },
				java = { "prettier" },
				python = { "isort", "black" }, -- install with Mason ruff, isort, and ruff-lsp
				graphql = { "prettier" },
			},
			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes

				-- local ignore_filetypes = { "sql", "java" }
				-- if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				-- 	return
				-- end

				-- Disable with a global or buffer-local variable
				-- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				--	return
				-- end
				-- Disable autoformat for files in a certain path
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("^/Users/jaime/projects/Glewee/glewee%-py/") then
					return
				end
				if bufname:match("^/Users/jaime/projects/Glewee/backend/theglew%-backend/") then
					return
				end
				if bufname:match("^/Users/jaime/projects/Glewee/payment%-service/") then
					return
				end
				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 10000,
				}
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
