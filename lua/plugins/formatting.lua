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
                graphql = { "prettier" },
                lua = { "stylua" },
                apex = { "prettier" },
                cls = { "prettier" },
                st = { "prettier" },
                java = { "prettier" },
                python = { "isort", "ruff_format" }, -- install with Mason ruff, isort, and ruff-lsp
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 5000,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
