require("dap-vscode-js").setup({
	debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- Instala con Lazy
	adapters = {
		"chrome",
		"pwa-node",
		"pwa-chrome",
		"pwa-msedge",
		"node-terminal",
		"pwa-extensionHost",
		"node",
	},
	log_console_level = vim.log.levels.ERROR,
})

local js_based_languages = { "typescript", "javascript", "typescriptreact" }
local dap = require("dap")

--dap.set_log_level("TRACE")

dap.adapters["pwa-chrome"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			require("mason-registry").get_package("js-debug-adapter"):get_install_path()
				.. "/js-debug/src/dapDebugServer.js",
			"${port}",
		},
	},
}

for _, language in ipairs(js_based_languages) do
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-chrome",
			request = "launch",
			name = 'Launch Chrome with "localhost"',
			url = function()
				local co = coroutine.running()
				return coroutine.create(function()
					vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
						if url == nil or url == "" then
							return
						else
							coroutine.resume(co, url)
						end
					end)
				end)
			end,
			webRoot = "${workspaceFolder}",
			userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
	}
end
