local signs = { Error = " ", Warn = "⚠️ ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	-- Usa la nueva API para definir los signos
	vim.diagnostic.config({
		virtual_text = true,
		signs = {
			[type] = { text = icon, texthl = "DiagnosticSign" .. type, numhl = "DiagnosticSign" .. type },
		},
	})
end

-- for type, icon in pairs(signs) do
-- 	local hl = "DiagnosticSign" .. type
-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end
