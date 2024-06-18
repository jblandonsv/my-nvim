return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "python", "rust", "java", "json", "bash", "terraform", "scss", "svelte", "vue", "xml", "yaml", "typescript"},
	  auto_install = true,
          sync_install = false,
          highlight = { enable = true, additional_vim_regex_highlightin = false, },
        })
    end
 }
