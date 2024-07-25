require("lspconfig").apex_ls.setup({
	apex_jar_path = "/Users/jaime/apex/apex-jorje-lsp.jar",
	apex_enable_semantic_errors = false, -- Whether to allow Apex Language Server to surface semantic errors
	apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
	filetypes = { "cls", "trigger", "apex", "st", "java" },
})
