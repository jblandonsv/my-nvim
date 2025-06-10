local function show_lsp_info_float()
	local clients = vim.lsp.get_active_clients()
	if vim.tbl_isempty(clients) then
		vim.notify("No active LSP clients", vim.log.levels.INFO)
		return
	end

	local lines = {}
	for _, client in ipairs(clients) do
		table.insert(lines, "Name: " .. client.name)
		table.insert(lines, "  ID: " .. client.id)
		table.insert(lines, "  Root dir: " .. (client.config.root_dir or "N/A"))
		table.insert(lines, "  Buffers:")
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.lsp.buf_is_attached(buf, client.id) then
				table.insert(lines, "    " .. vim.api.nvim_buf_get_name(buf))
			end
		end
		table.insert(lines, "") -- extra newline between clients
	end

	-- create a new scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- window size
	local width = math.floor(vim.o.columns * 0.7)
	local height = math.min(30, #lines)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- open floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	-- map "q" to close the window
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, nowait = true, silent = true })
end

-- Command to open it
vim.api.nvim_create_user_command("LspInfoFloat", show_lsp_info_float, {})
