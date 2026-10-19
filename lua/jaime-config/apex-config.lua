vim.lsp.config("apex_ls", {
	apex_jar_path = "/Users/jaime/apex/apex-jorje-lsp.jar",
	apex_enable_semantic_errors = false,
	apex_enable_completion_statistics = false,
	filetypes = { "cls", "trigger", "apex", "st", "java" },
})
vim.lsp.enable("apex_ls")
